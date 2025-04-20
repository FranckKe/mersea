<script setup lang="ts">
defineProps<{
  title?: string
}>()
</script>

<template>
  <div class="max-w-screen-md mx-auto pt-[100px] p-2">
    <h1 v-if="title" class="text-3xl lg:text-4xl mb-6 lg:mb-8">{{ title }}</h1>
    <slot />
  </div>
</template>
