<template>
  <article class="card">
    <div class="card-image">
      <div
        class="img-wrapper image"
        :style="`background-image: url('${apiUrl}${tracer.photo}') `"
      ></div>
    </div>
    <div class="card-content">
      <div class="content">
        <p class="title is-4">{{ tracer.name | capitalize }}</p>
        <p>{{ tracer.description | capitalize }}</p>
        <p>
          <strong>{{ $t('origin') }}: </strong>
          {{ tracer.origin | capitalize }}
        </p>
        <p>
          <strong>{{ $t('kind') }}: </strong>
          {{ tracer.kind | capitalize }}
        </p>
        <p>
          <strong>{{ $t('created_at') }}: </strong>
          <time datetime="tracer.created_at | formatDate">{{
            tracer.created_at | formatDate
          }}</time>
        </p>
        <p>
          <strong>{{ $t('quantity') }}: </strong>
          {{ getReportCount()(tracer.id) }}
        </p>
        <p>
          <strong>{{ $t('distance_between_tracers') }}: </strong>
          {{ getFormattedReportsEveryDistance()(tracer.id) }}
        </p>
      </div>
    </div>
  </article>
</template>

<script>
import { createNamespacedHelpers } from 'vuex'
const reportsModule = createNamespacedHelpers('reports')

export default {
  name: 'TracerCard',
  props: ['tracer'],
  data() {
    return {
      apiUrl: this.$apiUrl
    }
  },
  computed: {},
  methods: {
    ...reportsModule.mapGetters([
      'getReportCount',
      'getFormattedReportsEveryDistance'
    ])
  }
}
</script>

<style lang="scss">
.img-wrapper {
  height: 254px;
  padding-top: 5px;
  background-repeat: no-repeat;
  background-position: center;
}

.card {
  height: 100%;
}

.card-content .content p {
  margin-bottom: 0.25em;
}
</style>

<i18n>
{
  "en": {
    "created_at": "Created at",
    "distance_between_tracers": "Distance between tracers",
    "kind": "Type",
    "name": "Name",
    "origin": "Origin",
    "quantity": "Reported quantity"
  },
  "fr": {
    "created_at": "Créé le",
    "distance_between_tracers": "Distance entre traceurs",
    "kind": "Type",
    "name": "Nom",
    "origin": "Origine",
    "quantity": "Quantité signalée"
  },
  "es": {
    "created_at": "Creado en",
    "origin": "Origen",
    "quantity": "Cantidad testificada",
    "distance_between_tracers": "Distancia entre trazadores",
    "name": "Apellido",
    "kind": "Tipo"
  }
}
</i18n>
