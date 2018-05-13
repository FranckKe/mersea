<template>
  <div class="">
    <div id="map" class="map"></div>
  </div>
</template>

<script>
import Vue from 'vue'
import mapboxgl from 'mapbox-gl'
import 'mapbox-gl/dist/mapbox-gl.css'
import MapboxGeocoder from '@mapbox/mapbox-gl-geocoder'
import '@mapbox/mapbox-gl-geocoder/dist/mapbox-gl-geocoder.css'
import MapPopup from './MapPopup.vue'

export default {
  data() {
    return {
      apiUrl: this.$apiUrl,
      MapPopup: Vue.extend(MapPopup),
      map: {}
    }
  },
  mounted() {
    this.createMap()
  },
  methods: {
    mapMouseMoved(e) {
      const features = this.map.queryRenderedFeatures(e.point, {
        layers: ['reports']
      })
      this.map.getCanvas().style.cursor = features.length ? 'pointer' : ''
    },
    addPopup(e) {
      const MapPopup = this.MapPopup
      const features = this.map.queryRenderedFeatures(e.point, {
        layers: ['reports']
      })
      if (!features.length) {
        return
      }

      const feature = features[0]

      new mapboxgl.Popup()
        .setLngLat(feature.geometry.coordinates)
        .setHTML('<div id="popupContent"></div>')
        .addTo(this.map)

      new MapPopup({
        propsData: {
          tracerThumbUrl: JSON.parse(feature.properties.tracer).photo,
          tracerName: JSON.parse(feature.properties.tracer).name,
          userName: JSON.parse(feature.properties.user).name,
          reportedAt: feature.properties.reported_at
        }
      }).$mount(`#popupContent`) // Manually mount component to
    },
    mapLoad: async function() {
      // const MapPopup = this.MapPopup
      try {
        let reports = await fetch(`${this.apiUrl}/reports`, {
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

      this.map.addLayer({
        id: 'reports',
        type: 'symbol',
        source: {
          type: 'geojson',
          data: geojson
        },
        layout: {
          'text-field': '{id}',
          'text-offset': [0, 0.6],
          'text-anchor': 'top'
        },
        paint: { 'text-color': 'white' }
      })

      for (let marker of geojson.features) {
        var el = document.createElement('div')

        el.innerHTML = `<svg height="41px" width="27px" viewBox="0 0 27 41"><g fill-rule="nonzero"><g transform="translate(3.0, 29.0)" fill="#000000"><ellipse opacity="0.04" cx="10.5" cy="5.80029008" rx="10.5" ry="5.25002273"></ellipse><ellipse opacity="0.04" cx="10.5" cy="5.80029008" rx="10.5" ry="5.25002273"></ellipse><ellipse opacity="0.04" cx="10.5" cy="5.80029008" rx="9.5" ry="4.77275007"></ellipse><ellipse opacity="0.04" cx="10.5" cy="5.80029008" rx="8.5" ry="4.29549936"></ellipse><ellipse opacity="0.04" cx="10.5" cy="5.80029008" rx="7.5" ry="3.81822308"></ellipse><ellipse opacity="0.04" cx="10.5" cy="5.80029008" rx="6.5" ry="3.34094679"></ellipse><ellipse opacity="0.04" cx="10.5" cy="5.80029008" rx="5.5" ry="2.86367051"></ellipse><ellipse opacity="0.04" cx="10.5" cy="5.80029008" rx="4.5" ry="2.38636864"></ellipse></g><g fill="${
          marker.properties.color
        }"><path d="M27,13.5 C27,19.074644 20.250001,27.000002 14.75,34.500002 C14.016665,35.500004 12.983335,35.500004 12.25,34.500002 C6.7499993,27.000002 0,19.222562 0,13.5 C0,6.0441559 6.0441559,0 13.5,0 C20.955844,0 27,6.0441559 27,13.5 Z"></path></g><g opacity="0.25" fill="#000000"><path d="M13.5,0 C6.0441559,0 0,6.0441559 0,13.5 C0,19.222562 6.7499993,27 12.25,34.5 C13,35.522727 14.016664,35.500004 14.75,34.5 C20.250001,27 27,19.074644 27,13.5 C27,6.0441559 20.955844,0 13.5,0 Z M13.5,1 C20.415404,1 26,6.584596 26,13.5 C26,15.898657 24.495584,19.181431 22.220703,22.738281 C19.945823,26.295132 16.705119,30.142167 13.943359,33.908203 C13.743445,34.180814 13.612715,34.322738 13.5,34.441406 C13.387285,34.322738 13.256555,34.180814 13.056641,33.908203 C10.284481,30.127985 7.4148684,26.314159 5.015625,22.773438 C2.6163816,19.232715 1,15.953538 1,13.5 C1,6.584596 6.584596,1 13.5,1 Z"></path></g><g transform="translate(6.0, 7.0)" fill="#FFFFFF"></g><g transform="translate(8.0, 8.0)"><circle fill="#000000" opacity="0.25" cx="5.5" cy="5.5" r="5.4999962"></circle><circle fill="#FFFFFF" cx="5.5" cy="5.5" r="5.4999962"></circle></g></g></svg>`

        new mapboxgl.Marker({ color: `${marker.properties.color}` })
          .setLngLat(marker.geometry.coordinates)
          .addTo(this.map)
      }
    },
    createMap() {
      mapboxgl.accessToken = process.env.MAPBOX_TOKEN
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
      this.map.on('click', 'reports', this.addPopup)
      this.map.on('mousemove', 'reports', this.mapMouseMoved)
    }
  }
}
</script>

<style>
.map {
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
