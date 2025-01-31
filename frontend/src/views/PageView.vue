<script setup lang="ts">
import { computed, onBeforeMount, ref } from "vue"
import { useRouter } from "vue-router"
import axios from "@/libs/axios"
import type { Page } from "@/types"

const router = useRouter()
const api_url = import.meta.env.VITE_APP_API_URL

const pages = ref<Page[]>([])
const page = computed(() => {
  const slug = router.currentRoute.value.params.id
  return pages.value?.find((page) => page.slug === slug)
})
// TODO have a get with id for route
console.log(page.value?.content)

// TODO on locale change, go to the relevant alias -> backend must have a single id for each localized group
onBeforeMount(() => {
  axios
    .get(`${api_url}/pages`)
    .then((response) => {
      pages.value = response.data
    })
    .catch((error) => {
      console.error(error)
    })
})
</script>

<template>
  <article v-html="page?.content" class="max-w-screen-md mx-auto"></article>
</template>
