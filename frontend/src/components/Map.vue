<script setup lang="ts">
import { onBeforeMount, ref } from "vue"
import "maplibre-gl/dist/maplibre-gl.css"
import { MglMap, MglNavigationControl, MglGeolocateControl } from "@indoorequal/vue-maplibre-gl"
import axios from "@/libs/axios"

const mapLibreApiKey = import.meta.env.VITE_MAPLIBRE_TOKEN
const api_url = import.meta.env.VITE_APP_API_URL

// apiUrl: this.$apiUrl,
// map: {},
// mapGeolocationControl: undefined,
// addReportMarker: '',
// popup: '',
// popupCluster: '',
// spiderifyAfterZoom: 12, // Spiderify after zoom N, zoom otherwise,
// maxLeavesToSpiderify: 255, // Max leave to display when spiderify to prevent filling the map with leaves,
// circleToSpiralSwitchover: 5, // When below number, will display leave as a circle. Over, as a spiral
// spiderifiedCluster: {}
// container: 'map',

// TODO risque de pas pouvoir utiliser la searchbar en passant par la lib...
// TODO seemsl like standard PascalCase component syntax does not work...

const center: [number, number] = [0, 46.2276]
const refreshExpiredTiles = false
const zoom = 5
const minZoom = 2
const maxZoom = 18 // TODO attention il y a un maxZoom - 1 dans la def du MapLibre
// const style = `mapbox://styles/mapbox/satellite-streets-v10?optimize=true&key=${mapLibreApiKey}`
const style = `https://api.maptiler.com/maps/streets-v2/style.json?key=${mapLibreApiKey}`

const reports = ref([])

onBeforeMount(() => {
  const minReportedAt = "2018-01-01"
  const maxReportedAt = new Date().toISOString().split("T")[0]
  // TODO difficultés à appeler cette ressource below...
  axios
    .get(
      `${api_url}/reports?r_min_reported_at=${minReportedAt}&r_max_reported_at=${maxReportedAt}`,
      {
        headers: {
          Accept: "application/geo+json",
          "Content-Type": "application/geo+json"
        }
      }
    )
    .then(response => {
      reports.value = response.data ?? []
    })
    .catch(error => {
      console.error(error)
    })
})
</script>

<template>
  <div id="map">
    <mgl-map
      :style="style"
      :center="center"
      :zoom="zoom"
      :min-zoom="minZoom"
      :max-zoom="maxZoom"
      :refresh-expired-tiles="refreshExpiredTiles"
      height="100dvh"
    >
      <mgl-navigation-control position="bottom-right" />
      <mgl-geolocate-control position="bottom-right" />
    </mgl-map>
  </div>
</template>

<style lang="css">
@import "maplibre-gl/dist/maplibre-gl.css";
</style>
