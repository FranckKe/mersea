<template>
  <div class>
    <div id="map" class="map"></div>
    <add-report></add-report>
  </div>
</template>

<script>
import { createNamespacedHelpers } from 'vuex'
const { mapGetters, mapActions } = createNamespacedHelpers('reports')
const addReportModule = createNamespacedHelpers('addReport')

import AddReport from '@/components/AddReport'

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
      newMarker: ''
    }
  },
  components: {
    AddReport
  },
  mounted() {
    this.initData()
  },
  watch: {
    '$i18n.locale': function() {
      moment.locale(this.$i18n.locale)
      this.map.destroy
      this.createMap()
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
    initData: async function() {
      moment.locale(this.$i18n.locale)
      try {
        await this.loadReports()
        this.createMap()
      } catch (e) {
        this.$toast.open({
          message: this.$t('map_init_failure'),
          duration: 5000,
          type: 'is-danger'
        })
      }
    },
    mapLoad: function() {
      const geojson = this.getReports()
      if (geojson == null) return false

      this.map.addSource('reports', {
        type: 'geojson',
        data: geojson,
        cluster: true,
        clusterMaxZoom: 10, // Disable clustering after zoom N
        clusterRadius: 15 // Radius to cluster points
      })

      this.map.addLayer({
        id: 'clusters',
        type: 'circle',
        source: 'reports',
        filter: ['has', 'point_count'],
        paint: {
          // Blue, 15px circles when point count is less than 100
          // Yellow, 20px circles when point count is between 100 and 300
          // Pink, 30px circles when point count is greater than or equal to 300
          'circle-stroke-width': 1,
          'circle-stroke-color': '#000',
          'circle-color': [
            'step',
            ['get', 'point_count'],
            '#51bbd6',
            100,
            '#f1f075',
            750,
            '#f28cb1'
          ],
          'circle-radius': [
            'step',
            ['get', 'point_count'],
            15,
            100,
            20,
            750,
            30
          ]
        }
      })

      this.map.addLayer({
        id: 'cluster-count',
        type: 'symbol',
        source: 'reports',
        filter: ['has', 'point_count'],
        layout: {
          'text-field': '{point_count_abbreviated}',
          'text-font': ['DIN Offc Pro Medium', 'Arial Unicode MS Bold'],
          'text-size': 12
        }
      })

      this.map.addLayer({
        id: 'unclustered-reports',
        type: 'circle',
        source: 'reports',
        filter: ['!', ['has', 'point_count']],
        paint: {
          'circle-color': ['get', 'color'],
          'circle-radius': 6,
          'circle-stroke-width': 2,
          'circle-stroke-color': '#fff'
        }
      })

      // Zoom on cluster click
      this.map.on('click', 'clusters', e => {
        let features = this.map.queryRenderedFeatures(e.point, {
          layers: ['clusters']
        })
        let clusterId = features[0].properties.cluster_id
        this.map
          .getSource('reports')
          .getClusterExpansionZoom(clusterId, (err, zoom) => {
            if (err) return

            this.map.easeTo({
              center: features[0].geometry.coordinates,
              zoom: zoom
            })
          })
      })

      this.map.on('mouseenter', 'clusters', () => {
        this.map.getCanvas().style.cursor = 'pointer'
      })
      this.map.on('mouseleave', 'clusters', () => {
        this.map.getCanvas().style.cursor = ''
      })

      // Add popup on report circle click
      this.map.on('click', 'unclustered-reports', e => {
        let coordinates = e.features[0].geometry.coordinates.slice()
        let reportProperties = e.features[0].properties
        let tracerProperties = JSON.parse(e.features[0].properties.tracer)
        let userProperties = JSON.parse(e.features[0].properties.user)

        // Ensure that if the map is zoomed out such that multiple
        // copies of the feature are visible, the popup appears
        // over the copy being pointed to.
        while (Math.abs(e.lngLat.lng - coordinates[0]) > 180) {
          coordinates[0] += e.lngLat.lng > coordinates[0] ? 360 : -360
        }

        new mapboxgl.Popup()
          .setLngLat(coordinates)
          .setHTML(
            `<article class="media">
                <div class="media-left">
                  <figure class="image is-64x64">
                    <img src="${this.apiUrl}${
              tracerProperties.photo
            }" alt="Image">
                  </figure>
                </div>
                <div class="media-content">
                  <div class="content">
                    <p>
                      <strong>${tracerProperties.name}</strong>
                      <br>
                      <small>
                        ${userProperties.name}
                      </small>
                      <br>
                      <small>
                        ${this.$i18n.t('quantity')}: ${
              reportProperties.quantity
            }
                      </small>
                      <br>
                      <small>${moment(reportProperties.reportedAt).format(
                        'LL'
                      )}</small>
                    </p>
                  </div>
                </div>
                <div class="media-right">
                </div>
              </article>`
          )
          .addTo(this.map)
      })

      this.map.on('mouseenter', 'unclustered-reports', () => {
        this.map.getCanvas().style.cursor = 'pointer'
      })

      this.map.on('mouseleave', 'unclustered-reports', () => {
        this.map.getCanvas().style.cursor = ''
      })
    },
    createMap() {
      mapboxgl.accessToken = process.env.VUE_APP_MAPBOX_TOKEN
      this.map = new mapboxgl.Map({
        container: 'map',
        style: 'mapbox://styles/mapbox/satellite-streets-v9',
        minzoom: 2,
        zoom: 5,
        center: [0, 46.2276]
      })

      if (this.isFormActive && this.coordinates !== '')
        this.newMarker = new mapboxgl.Marker()
          .setLngLat(this.coordinates.split(',').reverse())
          .addTo(this.map)

      this.map.on('click', async e => {
        if (!this.isFormActive || this.currentStep !== 0) return false
        if (this.newMarker !== '') this.newMarker.remove()

        this.newMarker = new mapboxgl.Marker()
          .setLngLat(e.lngLat)
          .addTo(e.target)

        this.coordinates = `${e.lngLat.lat}, ${e.lngLat.lng}`
        const res = await axios.get(
          `https://api.mapbox.com/geocoding/v5/mapbox.places/${e.lngLat.lng},${
            e.lngLat.lat
          }.json?access_token=${process.env.VUE_APP_MAPBOX_TOKEN}`
        )
        this.address =
          res.data.features.length > 0
            ? res.data.features[0].place_name
            : 'No address found'
      })

      let geolocator = new mapboxgl.GeolocateControl({
        positionOptions: {
          enableHighAccuracy: true
        },
        trackUserLocation: true
      })
      let geocoder = new MapboxGeocoder(
        {
          accessToken: mapboxgl.accessToken,
          language: this.$i18n.locale,
          placeholder: this.$i18n.t('search')
        },
        'top'
      )
      let scaler = new mapboxgl.ScaleControl()
      let navigater = new mapboxgl.NavigationControl()
      let language = new MapboxLanguage({
        defaultLanguage: this.$i18n.locale
      })
      this.map.addControl(language)
      this.map.addControl(scaler)
      this.map.addControl(geocoder, 'top-left')
      this.map.addControl(geolocator)
      this.map.addControl(navigater, 'bottom-right')
      this.map.on('load', this.mapLoad)
    },
    destroyMap() {},
    ...mapGetters(['getReports']),
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
    ...mapActions(['loadReports'])
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

<style>
.map {
  width: 100%;
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
  background-color: rgba(10, 10, 10, 0.2);
  border: none;
  border-radius: 290486px;
  cursor: pointer;
  display: inline-block;
  flex-grow: 0;
  flex-shrink: 0;
  font-size: 0;
  height: 24px;
  max-height: 24px;
  max-width: 24px;
  min-height: 24px;
  min-width: 24px;
  width: 24px;
  outline: 0;
  vertical-align: top;
  position: absolute;
  top: 5px;
  right: 5px;
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
}
</style>

<i18n>
{
  "en": {
    "quantity": "Quantity",
    "search": "Search",
    "map_init_failure": "Error initializing map"
  },
  "fr": {
    "quantity": "Quantité",
    "search": "Rechercher",
    "map_init_failure": "Échec d'initialisation de la carte"
  },
  "es": {
    "quantity": "Cantidad",
    "search": "Buscar",
    "map_init_failure": "Error al inicializar el mapa"
  }
}
</i18n>
