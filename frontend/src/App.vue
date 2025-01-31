<script setup lang="ts">
import { RouterView } from "vue-router"
import Toast from "primevue/toast"
import MainNav from "@/components/MainNav.vue"
</script>

<template>
  <Toast />
  <MainNav />

  <RouterView />
</template>
