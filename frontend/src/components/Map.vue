<script setup lang="ts">
import { onBeforeMount, onMounted, ref, watch } from "vue"
import "maplibre-gl/dist/maplibre-gl.css"
import maplibregl from "maplibre-gl"
import Spiderfy from "@nazka/map-gl-js-spiderfy"
import axios from "@/libs/axios"

const mapToken = import.meta.env.VITE_APP_MAP_TOKEN
const api_url = import.meta.env.VITE_APP_API_URL

const center: [number, number] = [0, 46.2276]

const zoom = 5
const minZoom = 2
const maxZoom = 18
const style = `https://api.maptiler.com/maps/hybrid/style.json?key=${mapToken}`

const reports = ref({
  type: "FeatureCollection",
  features: [],
} as GeoJSON.FeatureCollection)
const tracers = ref([])
var popup = ref<maplibregl.Popup | null>(null)

onBeforeMount(() => {
  const minReportedAt = "2018-01-01"
  const maxReportedAt = new Date().toISOString().split("T")[0]
  axios
    .get(
      `${api_url}/reports?r_min_reported_at=${minReportedAt}&r_max_reported_at=${maxReportedAt}`,
      {
        headers: {
          Accept: "application/geo+json",
          "Content-Type": "application/geo+json",
        },
      },
    )
    .then((response) => {
      reports.value = response.data ?? []
      console.log(`Reports Loaded !`, console.log(reports.value))
    })
    .catch((error) => {
      console.error(`Error during reports loading: ${error}`)
    })
  axios
    .get(`${api_url}/tracers`, {
      headers: {
        Accept: "application/geo+json",
        "Content-Type": "application/geo+json",
      },
    })
    .then((response) => {
      tracers.value = response.data ?? []
      console.log(`Tracers Loaded ! ${console.log(tracers.value)}`)
    })
    .catch((error) => {
      console.error(`Error during tracers loading: ${error}`)
    })
})

onMounted(() => {
  const map = new maplibregl.Map({
    container: "map",
    style: style,
    center: center,
    zoom: zoom,
    minZoom: minZoom,
    maxZoom: maxZoom - 1,
  })

  map.on("load", async () => {
    const { data: circleSdf } = await map.loadImage("/public/img/circle-sdf.png")
    const { data: piksailSdf } = await map.loadImage("/public/img/piksail.png")
    map.addImage("circle-image", circleSdf, { sdf: true })
    map.addImage("piksail-image", piksailSdf, { sdf: true })

    // https://github.com/nazka/map-gl-js-spiderfy?tab=readme-ov-file
    // https://codepen.io/nazka-mapps/pen/LYavNEJ

    // There are 3 total different layers used in the map
    // 1. unclusturedReportsLayer: This layer is used to show ??? on the map
    // 2. clusteredReports: This layer is used to show ??? on the map
    // 3. spiderLeavesPaint (property of spiderfy object): This layer is used to show unclustered reports in the spiderfy view
    // Technically unclusturedReportsLayer and spiderLeavesPaint should be styled the same way as they are supposed to show the same data

    map.addSource("reports", {
      type: "geojson",
      data: reports.value,
      cluster: true,
    })

    map.addLayer({
      id: "unclusturedReportsLayer",
      type: "symbol",
      source: "reports",
      layout: {
        "icon-image": "circle-image",
        "icon-allow-overlap": true,
      },
      paint: {
        "icon-color": ["get", "color"],
        "icon-halo-width": 4,
        "icon-halo-color": "#fff",
      },
    })

    map.addLayer({
      id: "clusteredReports",
      type: "symbol",
      source: "reports",
      layout: {
        // "icon-image": "piksail-image", // Not present in example
        "text-field": ["get", "point_count"],
        "text-size": 16,
        "text-allow-overlap": true,
        // "background-color": "pink",

        // "icon-size": ["step", ["get", "point_count"], 1.5, 100, 2.5, 350, 3.5, 500, 5],
      },
      paint: {
        "text-color": "#fff",
        "text-halo-color": "#000",
        "text-halo-width": 1.2,
        // "icon-color": [
        //   "step",
        //   ["get", "point_count"],
        //   "#4dd0e1",
        //   100,
        //   "#FFDC00",
        //   350,
        //   "#FF851B",
        //   500,
        //   "#FF4136",
        // ],
        // "icon-opacity": 1,
        // "icon-halo-width": 2,
        // "icon-halo-color": "#fff",
      },
    })

    const spiderfy = new Spiderfy(map, {
      onLeafClick: function (feature) {
        console.log("POPUUUUUUUUUUUUUUUUUUUUUUUUUUUUP")
        console.log(feature)

        let coordinates = feature.geometry.coordinates.slice()
        let reportProperties = feature.properties
        let tracerId = feature.properties.tracer_id
        let tracer = tracers.value.filter((tracer) => tracerId === tracer.id)[0]
        console.log("feature.properties.user", feature.properties)
        let userProperties = feature.properties.user
        let popupOption = {
          maxWidth: "none",
        }
        let currentPopup = ref<maplibregl.Popup | null>(null)
        // Ensure that if the map is zoomed out such that multiple
        // copies of the feature are visible, the popup appears
        // over the copy being pointed to.

        while (Math.abs(feature.geometry.coordinates[0] - coordinates[0]) > 180) {
          coordinates[0] += feature.geometry.coordinates[0] > coordinates[0] ? 360 : -360
        }

        popup.value = new maplibregl.Popup(popupOption)
        currentPopup = popup

        const humanizedShoreLength = () => {
          if (!reportProperties.shore_length || reportProperties.shore_length === "null") return ""

          return reportProperties.shore_length < 1000
            ? `${reportProperties.shore_length.toFixed(0)} m`
            : `${(reportProperties.shore_length / 1000).toFixed(3)} km`
        }

        // @ts-ignore
        currentPopup
          .value!.setLngLat(coordinates)
          .setHTML(
            `<article class="media">
                <div class="media-left">
                  <figure class="image">
                    <img src="${api_url}${tracer.photo}" alt="Image">
                  </figure>
                </div>
                <div class="media-content">
                  <div class="content">
                    <h5 class="title is-5"><b>${tracer.name}</b></h5>
                    <p>
                      ${reportProperties.quantity}${" "}
                      ${reportProperties.quantity} ${humanizedShoreLength()}
                    </p>
                    <p>${userProperties.name}</p>
                    <p>${reportProperties.reported_at}</p>
                  </div>
                </div>
                <div class="media-right">
                </div>
              </article>`,
          )
          .addTo(map)
      },
      minZoomLevel: 7,
      zoomIncrement: 2,
      closeOnLeafClick: false,
      circleSpiralSwitchover: 10,
      circleOptions: {
        leavesSeparation: 50,
        leavesOffset: [0, 0],
      },
      spiralOptions: {
        legLengthStart: 25,
        legLengthFactor: 2.2,
        leavesSeparation: 30,
        leavesOffset: [0, 0],
      },
      spiderLegsAreHidden: false,
      spiderLegsWidth: 2,
      spiderLegsColor: "grey",
      spiderLeavesPaint: { "icon-color": ["get", "color"] },
      maxLeaves: 255,
      renderMethod: "3D",
    }) // create a new spiderfy object

    // spiderfy.applyTo("markers") // apply to a cluster layer
    spiderfy.applyTo("unclusturedReportsLayer")
  })
})
</script>

<template>
  <div id="map"></div>
</template>

<style lang="css">
@import "maplibre-gl/dist/maplibre-gl.css";
body {
  margin: 0;
  padding: 0;
}

#map {
  position: absolute;
  top: 0;
  bottom: 0;
  width: 100%;
  height: 100%;
}
.media {
  color: black;
}
</style>
