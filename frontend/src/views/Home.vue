<template>
  <div class="home">
    <ToolBar></ToolBar>
    <div id="map" class="map">
      <b-loading
        :is-full-page="false"
        :active.sync="!this.isMapReady || this.getLoading()"
        :can-cancel="false"
      ></b-loading>
    </div>
    <add-report
      :mapGeolocationControl="this.mapGeolocationControl"
    ></add-report>
  </div>
</template>

<script>
import { createNamespacedHelpers } from 'vuex'
const reportsModule = createNamespacedHelpers('reports')
const addReportModule = createNamespacedHelpers('addReport')
const tracersModule = createNamespacedHelpers('tracers')

import AddReport from '@/components/AddReport'
import ToolBar from '@/components/ToolBar'

import mapboxgl from 'mapbox-gl'
import 'mapbox-gl/dist/mapbox-gl.css'
import MapboxGeocoder from '@mapbox/mapbox-gl-geocoder'
import '@mapbox/mapbox-gl-geocoder/dist/mapbox-gl-geocoder.css'
import MapboxLanguage from '@mapbox/mapbox-gl-language'

import moment from 'moment'
import axios from 'axios'

export default {
  data() {
    return {
      apiUrl: this.$apiUrl,
      map: {},
      mapGeolocationControl: undefined,
      newMarker: '',
      popup: '',
      popupCluster: '',
      maxZoom: 17,
      isMapReady: false,
      spiderifyAfterZoom: 12, // Spiderify after zoom N, zoom otherwise,
      maxLeavesToSpiderify: 255, // Max leave to display when spiderify to prevent filling the map with leaves,
      circleToSpiralSwitchover: 5, // When below number, will display leave as a circle. Over, as a spiral
      spiderifiedCluster: {}
    }
  },
  components: {
    AddReport,
    ToolBar
  },
  async mounted() {
    moment.locale(this.$i18n.locale)
    try {
      await Promise.all([
        this.loadReports({
          reported_at_min: this.$reported_at_min,
          reported_at_max: this.$reported_at_max
        }),
        this.createMap()
      ])
    } catch (error) {
      this.$toast.open({
        message: this.$t('map_init_failure'),
        duration: 5000,
        type: 'is-danger'
      })
      console.error(error)
    }
    this.mapLoad()
    this.$store.watch(
      (state, getters) => getters['tracers/getFilteredTracers'],
      filteredTracers => {
        // Return early if map is not ready
        if (this.map.getSource('reports') == null) return false
        if (this.map.getLayer('unclustered-reports') == null) return false
        if (this.popup) this.popup.remove()
        if (this.popupCluster) this.popupCluster.remove()
        // Reset map source data with filtered geojson
        this.map
          .getSource('reports')
          .setData(this.getFilteredReports()(filteredTracers))
      }
    )
    this.$store.watch(
      (state, getters) => getters['reports/getReports'],
      () => {
        // Return early if map is not ready
        if (this.map.getSource('reports') == null) return false
        if (this.map.getLayer('unclustered-reports') == null) return false
        if (this.popup) this.popup.remove()
        if (this.popupCluster) this.popupCluster.remove()
        // Reset map source data with filtered geojson
        this.map.getSource('reports').setData(this.getReports())
      }
    )
  },
  watch: {
    '$i18n.locale': async function() {
      moment.locale(this.$i18n.locale)
      this.map.destroy
      try {
        await Promise.all([
          this.loadReports({
            reported_at_min: this.$reported_at_min,
            reported_at_max: this.$reported_at_max
          }),
          this.createMap()
        ])
        this.mapLoad()
      } catch (error) {
        this.$toast.open({
          message: this.$t('map_init_failure'),
          duration: 5000,
          type: 'is-danger'
        })
        console.error(error)
      }
    },
    isFormActive: function(newValue) {
      if (newValue && this.coordinates !== '') {
        this.newMarker = new mapboxgl.Marker()
          .setLngLat(this.coordinates.split(',').reverse())
          .addTo(this.map)
      } else {
        if (this.newMarker !== '') this.newMarker.remove()
      }
    }
  },
  methods: {
    addReportPopup: function(e, cluster = false) {
      let coordinates = e.features[0].geometry.coordinates.slice()
      let reportProperties = e.features[0].properties
      let tracerId = e.features[0].properties.tracer_id
      let tracer = this.getTracerById()(tracerId)
      let userProperties = JSON.parse(e.features[0].properties.user)
      let popupOption = {
        maxWidth: 'none'
      }
      let currentPopup = {}
      // Ensure that if the map is zoomed out such that multiple
      // copies of the feature are visible, the popup appears
      // over the copy being pointed to.
      while (Math.abs(e.lngLat.lng - coordinates[0]) > 180) {
        coordinates[0] += e.lngLat.lng > coordinates[0] ? 360 : -360
      }

      if (cluster) {
        this.popupCluster = new mapboxgl.Popup(popupOption)
        currentPopup = this.popupCluster
      } else {
        this.popup = new mapboxgl.Popup(popupOption)
        currentPopup = this.popup
      }
      currentPopup
        .setLngLat(coordinates)
        .setHTML(
          `<article class="media">
                <div class="media-left">
                  <figure class="image">
                    <img src="${this.apiUrl}${tracer.photo}" alt="Image">
                  </figure>
                </div>
                <div class="media-content">
                  <div class="content">
                    <h5 class="title is-5"><b>${tracer.name}</b></h5>
                    <p>${this.$i18n.t('by')} ${userProperties.name}</p>
                    <p>
                      ${reportProperties.quantity}${' '}
                      ${this.$i18n.tc('object', reportProperties.quantity)}
                    </p>
                    <p>${this.$options.filters.formatDate(
                      reportProperties.reported_at
                    )}</p>
                  </div>
                </div>
                <div class="media-right">
                </div>
              </article>`
        )
        .addTo(this.map)
    },
    createMap() {
      return new Promise(resolve => {
        mapboxgl.accessToken = process.env.VUE_APP_MAPBOX_TOKEN
        this.map = new mapboxgl.Map({
          container: 'map',
          style: 'mapbox://styles/mapbox/satellite-streets-v10?optimize=true',
          minZoom: 3,
          zoom: 5,
          maxZoom: this.maxZoom - 1,
          center: [0, 46.2276],
          refreshExpiredTiles: false
        })

        // Restore marker if the page loads on a unfinished reporting
        if (this.isFormActive && this.coordinates !== '')
          this.newMarker = new mapboxgl.Marker()
            .setLngLat(this.coordinates.split(',').reverse())
            .addTo(this.map)

        this.map.on('click', async e => {
          if (
            this.map
              .queryRenderedFeatures(e.point)
              .filter(feature => feature.source === 'spider-leaves').length ===
            0
          )
            this.clearSpiderifiedCluster(this.map) // Clear spiderified cluster on base map click only

          if (!this.isFormActive || this.currentStep !== 0) return false
          if (this.newMarker !== '') this.newMarker.remove()

          this.newMarker = new mapboxgl.Marker()
            .setLngLat(e.lngLat)
            .addTo(e.target)

          this.coordinates = `${e.lngLat.lat}, ${e.lngLat.lng}`
          const res = await axios.get(
            `https://api.mapbox.com/geocoding/v5/mapbox.places/${e.lngLat.lng},${e.lngLat.lat}.json?access_token=${process.env.VUE_APP_MAPBOX_TOKEN}`,
            {
              timeout: 15000
            }
          )
          this.address =
            res.data.features.length > 0
              ? res.data.features[0].place_name
              : this.$t('no_address_found')
        })

        let geolocator = new mapboxgl.GeolocateControl({
          positionOptions: {
            enableHighAccuracy: true
          },
          trackUserLocation: true,
          showUserLocation: true
        })

        this.mapGeolocationControl = geolocator

        let geocoder = new MapboxGeocoder(
          {
            accessToken: mapboxgl.accessToken,
            language: this.$i18n.locale,
            placeholder: this.$i18n.t('search_location'),
            mapboxgl: mapboxgl,
            marker: false
          },
          'top'
        )
        let scaler = new mapboxgl.ScaleControl()
        let navigater = new mapboxgl.NavigationControl()
        let language = new MapboxLanguage({
          defaultLanguage: this.$i18n.locale
        })
        this.map
          .addControl(language)
          .addControl(scaler)
          .addControl(geocoder, 'top-left')
          .addControl(geolocator)
          .addControl(navigater, 'bottom-right')
          .on('load', () => resolve('done'))
      })
    },
    mapLoad: async function() {
      if (this.getErrors().length > 0) {
        this.isMapReady = true
        this.$toast.open({
          message: this.$t('map_init_failure'),
          duration: 5000,
          type: 'is-danger'
        })
        console.error(this.getErrors())
        return false
      }

      this.map
        .addSource('reports', {
          type: 'geojson',
          data: this.getReports(),
          cluster: true,
          clusterMaxZoom: this.maxZoom, // Disable clustering after zoom N
          clusterRadius: 42
        })
        .addLayer({
          id: 'clusters',
          type: 'circle',
          source: 'reports',
          filter: ['has', 'point_count'],
          minzoom: 3,
          maxzoom: this.maxZoom,
          paint: {
            'circle-stroke-width': 2,
            'circle-stroke-opacity': 0.93,
            'circle-stroke-color': [
              'step',
              ['get', 'point_count'],
              '#4dd0e1',
              100,
              '#FFDC00',
              350,
              '#FF851B',
              500,
              '#FF4136'
            ],
            'circle-opacity': 0.75,
            'circle-blur': 0.1,
            'circle-color': [
              'step',
              ['get', 'point_count'],
              '#4dd0e1',
              100,
              '#FFDC00',
              350,
              '#FF851B',
              500,
              '#FF4136'
            ],
            'circle-radius': [
              'step',
              ['get', 'point_count'],
              15,
              100,
              20,
              350,
              25,
              500,
              30
            ]
          }
        })
        .addLayer({
          id: 'cluster-count',
          type: 'symbol',
          source: 'reports',
          filter: ['has', 'point_count'],
          minzoom: 3,
          maxzoom: this.maxZoom,
          layout: {
            'text-field': '{point_count_abbreviated}',
            'text-font': ['DIN Offc Pro Medium', 'Arial Unicode MS Bold'],
            'text-size': 16
          },
          paint: {
            'text-color': '#fff',
            'text-halo-color': '#000',
            'text-halo-width': 1
          }
        })
        .addLayer({
          id: 'unclustered-reports',
          type: 'circle',
          source: 'reports',
          filter: ['!', ['has', 'point_count']],
          minzoom: 3,
          maxzoom: this.maxZoom,
          paint: {
            'circle-color': ['get', 'color'],
            'circle-radius': 10,
            'circle-stroke-width': 2,
            'circle-stroke-color': '#fff'
          }
        })
        .on('click', 'clusters', e => {
          let features = this.map.queryRenderedFeatures(e.point, {
            layers: ['clusters']
          })
          let clusterId = features[0].properties.cluster_id

          // Zoom on cluster or spiderify it
          if (this.map.getZoom() < this.spiderifyAfterZoom) {
            this.map
              .getSource('reports')
              .getClusterExpansionZoom(clusterId, (err, zoom) => {
                if (err) return
                this.map.easeTo({
                  center: features[0].geometry.coordinates,
                  zoom: zoom
                })
              })
          } else {
            this.spiderifiedCluster = {
              id: clusterId,
              coordinates: features[0].geometry.coordinates
            }
            this.spiderifyCluster({
              map: this.map,
              source: 'reports',
              clusterToSpiderify: this.spiderifiedCluster
            })
          }
        })
        // Add popup on report circle click
        .on('click', 'unclustered-reports', e => {
          this.addReportPopup(e)
        })
        .on('click', 'spider-leaves', e => {
          this.addReportPopup(e, true)
        })
        .on('mouseenter', 'unclustered-reports', () => {
          this.map.getCanvas().style.cursor = 'pointer'
        })
        .on('mouseleave', 'unclustered-reports', () => {
          this.map.getCanvas().style.cursor = ''
        })
        .on('zoomstart', () => {
          this.clearSpiderifiedCluster(this.map)
        })

      this.isMapReady = true
    },
    ...reportsModule.mapGetters([
      'getReports',
      'getFilteredReports',
      'getLoading',
      'getErrors'
    ]),
    removeSourceAndLayer: function(map, id) {
      if (map.getLayer(id) != null) map.removeLayer(id)
      if (map.getSource(id) != null) map.removeSource(id)
    },
    clearSpiderifiedCluster: function(map) {
      if (this.popupCluster) this.popupCluster.remove()
      this.spiderifiedCluster = {}
      this.spiderLeavesCollection = []
      this.removeSourceAndLayer(map, 'spider-legs')
      this.removeSourceAndLayer(map, 'spider-leaves')
    },
    generateEquidistantPointsInCircle: function({
      totalPoints = 1,
      options = { distanceBetweenPoints: 50 }
    }) {
      let points = []
      let theta = (Math.PI * 2) / totalPoints
      let angle = theta
      for (let i = 0; i < totalPoints; i++) {
        angle = theta * i
        points.push({
          x: options.distanceBetweenPoints * Math.cos(angle),
          y: options.distanceBetweenPoints * Math.sin(angle)
        })
      }
      return points
    },
    generateEquidistantPointsInSpiral: function({
      totalPoints = 10,
      options = {
        rotationsModifier: 1250, // Higher modifier: closer spiral lines
        distanceBetweenPoints: 32, // Distance between points in spiral
        radiusModifier: 50000, // Spiral radius
        lengthModifier: 1000 // Spiral length modifier
      }
    }) {
      let points = []
      // Higher modifier = closer spiral lines
      const rotations = totalPoints * options.rotationsModifier
      const distanceBetweenPoints = options.distanceBetweenPoints
      const radius = totalPoints * options.radiusModifier
      // Value of theta corresponding to end of last coil
      const thetaMax = rotations * 2 * Math.PI
      // How far to step away from center for each side.
      const awayStep = radius / thetaMax
      for (
        let theta = distanceBetweenPoints / awayStep;
        points.length <= totalPoints + options.lengthModifier;

      ) {
        points.push({
          x: Math.cos(theta) * (awayStep * theta),
          y: Math.sin(theta) * (awayStep * theta)
        })
        theta += distanceBetweenPoints / (awayStep * theta)
      }
      return points.slice(0, totalPoints)
    },
    generateLeavesCoordinates: function({ nbOfLeaves }) {
      let points = []
      // Position cluster's leaves in circle if below threshold, spiral otherwise
      if (nbOfLeaves < this.circleToSpiralSwitchover) {
        points = this.generateEquidistantPointsInCircle({
          totalPoints: nbOfLeaves
        })
      } else {
        points = this.generateEquidistantPointsInSpiral({
          totalPoints: nbOfLeaves
        })
      }
      return points
    },
    spiderifyCluster: function({ map, source, clusterToSpiderify }) {
      this.spiderLegsCollection = []
      this.spiderLeavesCollection = []

      this.map
        .getSource(source)
        .getClusterLeaves(
          clusterToSpiderify.id,
          this.maxLeavesToSpiderify,
          0,
          (error, features) => {
            if (error) {
              console.warning('Cluster does not exists on this zoom')
              return
            }

            let leavesCoordinates = this.generateLeavesCoordinates({
              nbOfLeaves: features.length
            })

            let clusterXY = map.project(clusterToSpiderify.coordinates)

            // Generate spiderlegs and leaves coordinates
            features.forEach((element, index) => {
              let spiderLeafLatLng = map.unproject([
                clusterXY.x + leavesCoordinates[index].x,
                clusterXY.y + leavesCoordinates[index].y
              ])

              this.spiderLeavesCollection.push({
                type: 'Feature',
                geometry: {
                  type: 'Point',
                  coordinates: [spiderLeafLatLng.lng, spiderLeafLatLng.lat]
                },
                properties: element.properties
              })

              this.spiderLegsCollection.push({
                type: 'Feature',
                geometry: {
                  type: 'LineString',
                  coordinates: [
                    clusterToSpiderify.coordinates,
                    [spiderLeafLatLng.lng, spiderLeafLatLng.lat]
                  ]
                }
              })
            })

            // Draw spiderlegs and leaves coordinates
            map.addLayer({
              id: 'spider-legs',
              type: 'line',
              source: {
                type: 'geojson',
                data: {
                  type: 'FeatureCollection',
                  features: this.spiderLegsCollection
                }
              },
              paint: {
                'line-width': 3,
                'line-color': 'rgba(128, 128, 128, 0.5)'
              }
            })

            map.addLayer({
              id: 'spider-leaves',
              type: 'circle',
              source: {
                type: 'geojson',
                data: {
                  type: 'FeatureCollection',
                  features: this.spiderLeavesCollection
                }
              },
              paint: {
                'circle-color': ['get', 'color'],
                'circle-radius': 10,
                'circle-stroke-width': 2,
                'circle-stroke-color': '#fff'
              }
            })
          }
        )
    },
    ...tracersModule.mapGetters(['getTracerById', 'getFilteredTracers']),
    ...addReportModule.mapGetters([
      'getCurrentStep',
      'getAddress',
      'getIsFormActive',
      'getCoordinates'
    ]),
    ...addReportModule.mapMutations([
      'setCurrentStep',
      'setAddress',
      'setIsFormActive',
      'setCoordinates'
    ]),
    ...reportsModule.mapActions(['loadReports'])
  },
  computed: {
    ...addReportModule.mapState({
      currentStep: state => state.currentStep
    }),
    currentStep: {
      set(value) {
        this.setCurrentStep(value)
      },
      get() {
        return this.getCurrentStep()
      }
    },
    ...addReportModule.mapState({
      address: state => state.address
    }),
    address: {
      set(value) {
        this.setAddress(value)
      },
      get() {
        return this.getAddress()
      }
    },
    ...addReportModule.mapState({
      coordinates: state => state.coordinates
    }),
    coordinates: {
      set(value) {
        this.setCoordinates(value)
      },
      get() {
        return this.getCoordinates()
      }
    },
    ...addReportModule.mapState({
      isFormActive: state => state.isFormActive
    }),
    isFormActive: {
      set(value) {
        this.setIsFormActive(value)
      },
      get() {
        return this.getIsFormActive()
      }
    }
  }
}
</script>

<style lang="scss">
.home {
  display: flex;
  flex-direction: row;
  height: 100%;
  width: 100%;
}

.map {
  width: calc(100% - 125px); /* toolbar width */
  position: fixed;
  right: 0;
  height: calc(100vh - 55px); /* header height + margin */
}

.mapboxgl-ctrl-group > button {
  width: 40px;
  height: 40px;
}

.mapboxgl-ctrl-top-left,
.mapboxgl-ctrl-geocoder {
  width: calc(100% - 35px); /* Width of geolocalize button */
  max-width: calc(100% - 35px);
}

.mapboxgl-popup-close-button {
  -webkit-appearance: none;
  border-radius: 4px;
  cursor: pointer;
  display: inline-block;
  flex-grow: 0;
  flex-shrink: 0;
  font-size: 0;
  height: 28px;
  max-height: 28px;
  max-width: 28px;
  min-height: 28px;
  min-width: 28px;
  width: 28px;
  outline: 0;
  vertical-align: top;
  position: absolute;
  top: 5px;
  right: 5px;
  background-color: #ff3860;
  border-color: transparent;
  color: #fff;
}

.mapboxgl-popup-content .mapboxgl-popup-close-button:hover {
  background-color: #ff3860;
}

.mapboxgl-popup-close-button::before,
.mapboxgl-popup-close-button::after {
  background-color: #fff;
  content: '';
  display: block;
  left: 50%;
  position: absolute;
  top: 50%;
  -webkit-transform: translateX(-50%) translateY(-50%) rotate(45deg);
  transform: translateX(-50%) translateY(-50%) rotate(45deg);
  -webkit-transform-origin: center center;
  transform-origin: center center;
}

.mapboxgl-popup-close-button::before {
  height: 2px;
  width: 50%;
}

.mapboxgl-popup-close-button::after {
  height: 50%;
  width: 2px;
}

.mapboxgl-popup-close-button:hover {
  background-color: rgba(0, 0, 0, 0.5);
}

/* Style mapbox popup as Bulma .box */
.mapboxgl-popup-content {
  background-color: white;
  border-radius: 5px;
  -webkit-box-shadow: 0 2px 3px rgba(10, 10, 10, 0.1),
    0 0 0 1px rgba(10, 10, 10, 0.1);
  box-shadow: 0 2px 3px rgba(10, 10, 10, 0.1), 0 0 0 1px rgba(10, 10, 10, 0.1);
  color: #4a4a4a;
  display: block;
  padding: 1.25rem;
  padding-right: 0;

  .media {
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: row;
  }

  .media-content {
    font-size: 1rem;
    min-width: 125px;
    max-width: 175px;
    align-self: flex-start;

    h5 {
      display: inline-block;
      max-width: calc(100% - 20px);
    }

    h5:first-letter {
      text-transform: uppercase;
    }

    p {
      margin-bottom: 0.5rem;
      word-break: break-word;
    }
  }

  .image {
    width: 128px;
  }
}

.loading-overlay.is-active {
  z-index: 20;
}

@media only screen and (max-device-width: 1024px) {
  .home {
    flex-direction: column;
  }

  .map {
    width: 100vw;
    height: calc(100vh - 56px);
    top: 56px;
  }

  .mapboxgl-popup-content {
    padding: 0.5rem;

    .media {
      flex-direction: column-reverse;
    }

    .media-left {
      margin-right: 0;
    }

    .media-content {
      font-size: 0.75rem;
      max-width: 200px;
      margin-bottom: 0.5rem;
      width: 100%;

      h5 {
        margin-bottom: 0.5rem;
      }

      p {
        margin-bottom: 0;
      }
    }
  }
}
</style>

<i18n>
{
  "en": {
    "object": "item | items",
    "search_location": "Find a place",
    "no_address_found": "No address found",
    "by": "By",
    "map_init_failure": "Error initializing map"
  },
  "fr": {
    "object": "exemplaire | exemplaires",
    "search_location": "Rechercher un endroit",
    "no_address_found": "Pas d'adresse trouvée",
    "by": "Par",
    "map_init_failure": "Échec d'initialisation de la carte"
  },
  "es": {
    "object": "objeto | objetos",
    "search_location": "Encontrar un lugar",
    "no_address_found": "No se encontró dirección",
    "by": "pro",
    "map_init_failure": "Error al inicializar el mapa"
  }
}
</i18n>
