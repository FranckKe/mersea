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
            <p><strong>{{ $t('origin') }}: </strong>{{ tracer.origin }}</p>
            <p><strong>{{ $t('type') }}: </strong>{{ tracer.kind }}</p>
            <p><strong>{{ $t('created_at') }}: </strong><time datetime="tracer.created_at | formatDate">{{ tracer.created_at | formatDate }}</time></p>
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

<style scoped>
</style>

<i18n>
{
  "en": {
    "created_at": "Created at",
    "origin": "Origin",
    "type": "Type"
  },
  "fr": {
    "created_at": "Créé le",
    "origin": "Origine",
    "type": "Type"
  },
  "es": {
    "created_at": "Creado en",
    "origin": "Origen",
    "type": "Tipo"
  }
}
</i18n>
