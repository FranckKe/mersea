<template>
  <div class="columns is-multiline is-mobile">
    <div
      class="column is-full-mobile is-half-tablet is-one-third-desktop"
      :key="idx"
      v-for="(tracer, idx) in tracers"
    >
      <article class="card">
        <div class="card-image">
          <div
            class="img-wrapper image"
            :style="`background-image: url('${apiUrl}${tracer.photo}') `"
          ></div>
        </div>
        <div class="card-content">
          <div class="content">
            <p class="title is-4">{{ tracer.name }}</p>
            <p>{{ tracer.description }}</p>
            <p>
              <strong>{{ $t('origin') }}:</strong>
              {{ tracer.origin }}
            </p>
            <p>
              <strong>{{ $t('type') }}:</strong>
              {{ tracer.kind }}
            </p>
            <p>
              <strong>{{ $t('created_at') }}:</strong>
              <time datetime="tracer.created_at | formatDate">
                {{ tracer.created_at | formatDate }}
              </time>
            </p>
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
.img-wrapper {
  height: 254px;
  padding-top: 5px;
  background-repeat: no-repeat;
  background-position: center;
}

.card-content .content p {
  margin-bottom: 0.25em;
}
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
