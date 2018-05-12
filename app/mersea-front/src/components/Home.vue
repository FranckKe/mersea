<template>
  <div class="">
    <div id="map"></div>
  </div>
</template>

<script>
/* eslint-disable no-undef */
import mapboxgl from 'mapbox-gl'
import 'mapbox-gl/dist/mapbox-gl.css'
import MapboxGeocoder from '@mapbox/mapbox-gl-geocoder'
import '@mapbox/mapbox-gl-geocoder/dist/mapbox-gl-geocoder.css'
import moment from 'moment'

export default {
  data() {
    return {
      apiUrl: this.$apiUrl
    }
  },
  mounted() {
    this.createMap()
  },
  methods: {
    createMap: function() {
      const apiUrl = this.apiUrl
      mapboxgl.accessToken =
        'pk.eyJ1IjoiZnJhbmNrayIsImEiOiJjamc5ODhrazUzaXlvMndvaDBzMnZoZXF6In0.ThvS99eoVrbmTC_KAmv_6w'
      this.map = new mapboxgl.Map({
        container: 'map',
        style: 'mapbox://styles/mapbox/satellite-streets-v9',
        minzoom: 2,
        zoom: 5,
        center: [0, 46.2276]
      })

      this.map.addControl(new mapboxgl.ScaleControl())
      this.map.addControl(
        new MapboxGeocoder(
          {
            accessToken: mapboxgl.accessToken
          },
          'top'
        ),
        'top-left'
      )
      this.map.addControl(
        new mapboxgl.GeolocateControl({
          positionOptions: {
            enableHighAccuracy: true
          },
          trackUserLocation: true
        })
      )
      this.map.addControl(new mapboxgl.NavigationControl(), 'bottom-right')
      this.map.on('load', async () => {
        try {
          let reports = await fetch(`${apiUrl}/reports`, {
            method: 'get',
            headers: new Headers({
              Accept: 'application/geo+json',
              'Content-Type': 'application/geo+json'
            })
          })
          var geojson = await reports.json()
        } catch (e) {
          throw e
        }

        for (let marker of geojson.features) {
          new mapboxgl.Marker({ color: marker.properties.color })
            .setLngLat(marker.geometry.coordinates)
            .setPopup(
              new mapboxgl.Popup({ offset: 25, className: 'box' }).setHTML(`
  <article class="media">
    <div class="media-left">
      <figure class="image is-64x64">
        <img src="${apiUrl}${marker.properties.tracer.photo}" alt="Image">
      </figure>
    </div>
    <div class="media-content">
      <div class="content">
        <p>
          <strong>${marker.properties.tracer.name}</strong><br><small>${
                marker.properties.user.name
              }</small><br><small>${moment(
                marker.properties.reported_at
              ).format('LL')}</small>
        </p>
      </div>
    </div>
    <div class="media-right">
    </div>
  </article>`)
            )
            .addTo(this.map)
        }
      })
    }
  }
}
</script>

<style>
#map {
  width: 100%;
  height: calc(100vh - var(--header-height));
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
  height: 20px;
  max-height: 20px;
  max-width: 20px;
  min-height: 20px;
  min-width: 20px;
  outline: 0;
  vertical-align: top;
  width: 20px;
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
</style>
