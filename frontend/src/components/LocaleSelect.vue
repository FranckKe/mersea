<script setup lang="ts">
import { watch } from "vue"
import { useI18n } from "vue-i18n"
import Select from "primevue/select"
import dayjs from "@/libs/dayjs"

const { availableLocales, locale } = useI18n()

// Day.js does not detect locale change by itself, so we need to do it manually
watch(locale, newValue => {
  dayjs.locale(newValue)
})
</script>

<template>
  <Select v-model="locale" :options="availableLocales" />
</template>
