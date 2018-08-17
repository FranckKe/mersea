<template>
  <div class="columns is-multiline is-mobile">
    <div class="column is-half-mobile is-one-third-tablet is-one-quarter-desktop" :key="idx" v-for="(tracer, idx) in tracers">
      <article class="card">
        <div class="card-image">
          <router-link :to="`/tracers/${tracer.id}`">
          <div class="img-wrapper" :style="`background-image: url('${apiUrl}${tracer.photo}')`">
          </div>
          </router-link>
        </div>
        <div class="card-content">
          <div class="content">
            <p class="title is-4"><router-link :to="`/tracers/${tracer.id}`">{{ tracer.name }}</router-link></p>
            <p>{{ tracer.description }}</p>
            <p><strong>Origin: </strong>{{ tracer.origin }}</p>
            <p><strong>Type: </strong>{{ tracer.kind }}</p>
            <p><strong>Created at: </strong><time datetime="2016-1-1">{{ tracer.created_at | formatDate }}</time></p>
          </div>
        </div>
      </article>
    </div>
  </div>
</template>

<script>
export default {
  name: 'tracers-grid',
  props: ['tracers'],
  data() {
    return {
      apiUrl: this.$apiUrl
    }
  }
}
</script>

<style>
</style>
