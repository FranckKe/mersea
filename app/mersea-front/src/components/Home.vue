<template>
  <div class="">
  <div id="map"></div>
  </div>
</template>

<script>
import mapboxgl from 'mapbox-gl'
import 'mapbox-gl/dist/mapbox-gl.css'
import MapboxGeocoder from '@mapbox/mapbox-gl-geocoder'
import '@mapbox/mapbox-gl-geocoder/dist/mapbox-gl-geocoder.css'

export default {
  data() {
    return {}
  },
  mounted() {
    this.createMap()
    console.dir(mapboxgl)
  },
  methods: {
    createMap: () => {
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
</style>
