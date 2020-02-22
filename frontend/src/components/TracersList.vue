<template>
  <div class="tracers-list">
    <b-field grouped group-multiline>
      <b-select v-model="perPage">
        <option value="5">5 {{ $t('per_page') }}</option>
        <option value="10">10 {{ $t('per_page') }}</option>
        <option value="15">15 {{ $t('per_page') }}</option>
        <option value="20">20 {{ $t('per_page') }}</option>
      </b-select>
    </b-field>
    <b-table
      :data="tracers"
      :paginated="true"
      :per-page="perPage"
      :current-page.sync="currentPage"
      :pagination-simple="false"
      :default-sort-direction="defaultSortDirection"
      :opened-detailed="defaultOpenedDetails"
      default-sort="name"
      detailed
      striped
      detail-key="id"
    >
      <template slot-scope="props">
        <b-table-column field="name" v-bind:label="$t('name')" sortable>{{
          props.row.name
        }}</b-table-column>
        <b-table-column field="name" v-bind:label="$t('origin')" sortable>{{
          props.row.origin
        }}</b-table-column>
        <b-table-column field="kind" v-bind:label="$t('type')" sortable>{{
          props.row.kind
        }}</b-table-column>
        <b-table-column
          field="category"
          v-bind:label="$t('category')"
          sortable
          >{{ $t(props.row.category) }}</b-table-column
        >
        <b-table-column
          field="created_at"
          v-bind:label="$t('created_at')"
          sortable
          >{{ props.row.created_at | formatDate }}</b-table-column
        >
        <b-table-column
          field="reported_quantity"
          v-bind:label="$t('reported_quantity')"
          sortable
          width="100"
          centered
          :custom-sort="sortByReportedQuantity"
          >{{ getReportCount()(props.row.id) }}</b-table-column
        >
        <b-table-column
          field="distance_between_tracers"
          v-bind:label="$t('distance_between_tracers')"
          sortable
          width="100"
          centered
          :custom-sort="sortByQuantityPerKm"
          >{{
            $n(getReportsEveryKilometers()(props.row.id))
          }}
          km</b-table-column
        >
      </template>
      <template slot="detail" slot-scope="props">
        <article class="media">
          <figure class="media-left">
            <p class="image">
              <img :src="`${apiUrl}${props.row.photo}`" />
            </p>
          </figure>
          <div class="media-content">
            <div class="content">
              <p class="tracer-description">{{ props.row.description }}</p>
            </div>
          </div>
        </article>
      </template>
      <template slot="empty">
        <section class="section">
          <div class="content has-text-grey has-text-centered">
            <p>
              <b-icon icon="emoticon-sad" size="is-large"></b-icon>
            </p>
            <p>{{ $t('nothing') }}</p>
          </div>
        </section>
      </template>
    </b-table>
  </div>
</template>

<script>
import { createNamespacedHelpers } from 'vuex'
const { mapState, mapGetters, mapMutations } = createNamespacedHelpers(
  'tracers'
)
const reportsModule = createNamespacedHelpers('reports')

export default {
  name: 'tracers-list',
  props: ['tracers'],
  data() {
    return {
      apiUrl: this.$apiUrl,
      defaultSortDirection: 'asc',
      currentPage: 1,
      defaultOpenedDetails: [1]
    }
  },
  methods: {
    ...mapMutations(['setPerPage']),
    ...mapGetters(['getPerPage']),
    ...reportsModule.mapGetters([
      'getReportCount',
      'getReportsEveryKilometers'
    ]),
    sortByReportedQuantity: function(tracerA, tracerB, isAsc) {
      const reportCountA = this.getReportCount()(tracerA.id)
      const reportCountB = this.getReportCount()(tracerB.id)

      return isAsc ? reportCountA - reportCountB : reportCountB - reportCountA
    },
    sortByQuantityPerKm: function(tracerA, tracerB, isAsc) {
      const reportCountPerKmA = this.getReportsEveryKilometers()(tracerA.id)
      const reportCountPerKmB = this.getReportsEveryKilometers()(tracerB.id)

      return isAsc
        ? reportCountPerKmA - reportCountPerKmB
        : reportCountPerKmB - reportCountPerKmA
    }
  },
  computed: {
    ...mapState({
      perPage: state => state.perPage
    }),
    // Two-way Computed Property
    perPage: {
      set(value) {
        this.setPerPage(value)
      },
      get() {
        return this.getPerPage()
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.tracer-description {
  max-width: 700px;
}

.tracers-list {
  width: 100%;
}

.detail .image {
  width: 128px;
}
</style>

<i18n>
{
  "en": {
    "category": "Category",
    "created_at": "Created at",
    "name": "Name",
    "nothing": "No data",
    "origin": "Origin",
    "per_page": "per page",
    "reported_quantity": "Reported quantity",
    "distance_between_tracers": "Distance between tracers",
    "research": "Research",
    "drift": "Drift",
    "container": "Container",
    "archive": "Archive",
    "type": "Type"
  },
  "fr": {
    "category": "Categorie",
    "created_at": "Créé le",
    "name": "Nom",
    "nothing": "Pas de données",
    "origin": "Origine",
    "per_page": "par page",
    "reported_quantity": "Quantité signalée",
    "distance_between_tracers": "Distance entre traceurs",
    "research": "Recherche",
    "drift": "Dérive",
    "container": "Conteneur",
    "archive": "Archive",
    "type": "Type"
  },
  "es": {
    "category": "Categoría",
    "created_at": "Creado en",
    "name": "Apellido",
    "nothing": "Sin datos",
    "origin": "Origen",
    "per_page": "por página",
    "reported_quantity": "Cantidad testificada",
    "distance_between_tracers": "Distancia entre trazadores",
    "research": "Búsqueda",
    "drift": "Dériva",
    "container": "Envase",
    "archive": "Archivo",
    "type": "Tipo"
  }
}
</i18n>
