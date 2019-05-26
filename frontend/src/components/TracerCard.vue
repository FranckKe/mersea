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
        <p class="title is-4">{{ tracer.name }}</p>
        <p>{{ tracer.description }}</p>
        <p>
          <strong>{{ $t('origin') }}:</strong>
          {{ tracer.origin }}
        </p>
        <p>
          <strong>{{ $t('kind') }}:</strong>
          {{ tracer.kind }}
        </p>
        <p>
          <strong>{{ $t('created_at') }}:</strong>
          <time datetime="tracer.created_at | formatDate">
            {{ tracer.created_at | formatDate }}
          </time>
        </p>
        <p>
          <strong>{{ $t('quantity') }}:</strong>
          {{ getReportCount()(tracer.id) }}
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
    ...reportsModule.mapGetters(['getReportCount'])
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
    "origin": "Origin",
    "quantity": "Reported quantity",
    "name": "Name",
    "kind": "Type"
  },
  "fr": {
    "created_at": "Créé le",
    "origin": "Origine",
    "quantity": "Quantité signalée",
    "name": "Nom",
    "kind": "Type"
  },
  "es": {
    "created_at": "Creado en",
    "origin": "Origen",
    "quantity": "Cantidad testificada",
    "name": "Apellido",
    "kind": "Tipo"
  }
}
</i18n>
