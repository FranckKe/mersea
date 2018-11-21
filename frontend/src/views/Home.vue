<template>
  <div class="">
    <div id="map" class="map"></div>
    <add-report></add-report>
  </div>
</template>

<script>
import { createNamespacedHelpers } from 'vuex'
const { mapGetters } = createNamespacedHelpers('reports')
const addReportModule = createNamespacedHelpers('addReport')
import store from '../store'

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
    this.createMap()
    moment.locale(this.$i18n.locale)
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
        if (this.newMarker != '') this.newMarker.remove()
      }
    }
  },
  methods: {
    mapLoad: function() {
      const geojson = store.state.reports.data
      for (let marker of geojson.features) {
        new mapboxgl.Marker({ color: `${marker.properties.color}` })
          .setLngLat(marker.geometry.coordinates)
          .setPopup(
            new mapboxgl.Popup({ offset: 25 }).setHTML(
              `<article class="media">
                <div class="media-left">
                  <figure class="image is-64x64">
                    <img src="${this.apiUrl}${
                marker.properties.tracer.photo
              }" alt="Image">
                  </figure>
                </div>
                <div class="media-content">
                  <div class="content">
                    <p>
                      <strong>${marker.properties.tracer.name}</strong>
                      <br>
                      <small>
                        ${marker.properties.user.name}
                      </small>
                      <br>
                      <small>
                        ${this.$i18n.t('quantity')}: ${
                marker.properties.quantity
              }
                      </small>
                      <br>
                      <small>${moment(marker.properties.reportedAt).format(
                        'LL'
                      )}</small>
                    </p>
                  </div>
                </div>
                <div class="media-right">
                </div>
              </article>`
            )
          )
          .addTo(this.map)
      }

      this.map.addLayer({
        id: 'reports',
        type: 'symbol',
        layout: {
          'icon-allow-overlap': false
        },
        source: {
          type: 'geojson',
          data: geojson
        }
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

      if (this.coordinates !== '')
        this.newMarker = new mapboxgl.Marker()
          .setLngLat(this.coordinates.split(',').reverse())
          .addTo(this.map)

      this.map.on('click', async e => {
        if (!this.isFormActive) return false
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
    ...mapGetters(['getData']),
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
    ])
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

@media only screen and (max-device-width: 1024px) {
  .map {
    height: 46vh;
  }
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
    "search": "Search"
  },
  "fr": {
    "quantity": "Quantité",
    "search": "Rechercher"
  },
  "es": {
    "quantity": "Cantidad",
    "search": "Buscar"
  }
}
</i18n>
