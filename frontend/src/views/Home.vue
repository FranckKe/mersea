<template>
  <div class="">
    <div id="map" class="map"></div>
  </div>
</template>

<script>
import { createNamespacedHelpers } from 'vuex'
const { mapGetters } = createNamespacedHelpers('reports')
import store from '../store'

import mapboxgl from 'mapbox-gl'
import 'mapbox-gl/dist/mapbox-gl.css'
import MapboxGeocoder from '@mapbox/mapbox-gl-geocoder'
import '@mapbox/mapbox-gl-geocoder/dist/mapbox-gl-geocoder.css'
import moment from 'moment'

export default {
  data() {
    return {
      apiUrl: this.$apiUrl,
      map: {}
    }
  },
  mounted() {
    this.createMap()
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
                        Quantity: ${marker.properties.quantity}
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
      let geolocator = new mapboxgl.GeolocateControl({
        positionOptions: {
          enableHighAccuracy: true
        },
        trackUserLocation: true
      })
      let geocoder = new MapboxGeocoder(
        { accessToken: mapboxgl.accessToken },
        'top'
      )
      let scaler = new mapboxgl.ScaleControl()
      let navigater = new mapboxgl.NavigationControl()

      this.map.addControl(scaler)
      this.map.addControl(geocoder, 'top-left')
      this.map.addControl(geolocator)
      this.map.addControl(navigater, 'bottom-right')
      this.map.on('load', this.mapLoad)
    },
    ...mapGetters(['getData'])
  }
}
</script>

<style>
.map {
  width: 100%;
  height: 100vh;
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
