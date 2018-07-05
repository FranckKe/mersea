<template>
  <div class="columns is-multiline is-mobile">
    <div class="column is-half-mobile is-one-third-tablet is-one-quarter-desktop" :key="idx" v-for="(tracer, idx) in tracersData()">
      <article class="card">
        <div class="card-image">
          <router-link :to="`/tracers/${tracer.id}`">
          <div class="img-wrapper" :style="`background-image: url('${apiUrl}${tracer.photo}')`">
          </div>
          </router-link>
        </div>
        <div class="card-content">
          <router-link :to="`/tracers/${tracer.id}`">{{ tracer.name }}</router-link>
        </div>
      </article>
    </div>
  </div>
</template>

<script>
export default {
  name: "tracers-grid",
  props: ['tracers'],
  data() {
    return {
      apiUrl: this.$apiUrl,
      tracersData: this.tracers
    }
  }
}
</script>
