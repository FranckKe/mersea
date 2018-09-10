<template>
  <div>
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
      detail-key="id">
      <template slot-scope="props">
        <b-table-column field="name" v-bind:label="$t('name')" sortable>
          {{ props.row.name }}
        </b-table-column>
        <b-table-column field="name" v-bind:label="$t('origin')" sortable>
          {{ props.row.origin }}
        </b-table-column>
        <b-table-column field="kind" v-bind:label="$t('type')" sortable>
          {{ props.row.kind }}
        </b-table-column>
        <b-table-column field="created_at" v-bind:label="$t('created_at')" sortable>
          {{ props.row.created_at | formatDate }}
        </b-table-column>
      </template>
      <template slot="detail" slot-scope="props">
        <article class="media">
          <figure class="media-left">
            <p class="image is-64x64">
              <img :src="`${apiUrl}${props.row.photo}`">
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
              <b-icon
                icon="emoticon-sad"
                size="is-large">
              </b-icon>
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
    ...mapGetters(['getPerPage'])
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


<style>
.tracer-description {
  max-width: 700px;
}
</style>

<i18n>
{
  "en": {
    "created_at": "Created at",
    "name": "Name",
    "nothing": "No data",
    "origin": "Origin",
    "per_page": "per page",
    "type": "Type"
  },
  "fr": {
    "created_at": "Créé le",
    "name": "Nom",
    "nothing": "Pas de données",
    "origin": "Origine",
    "per_page": "par page",
    "type": "Type"
  },
  "es": {
    "created_at": "Creado en",
    "name": "Apellido",
    "nothing": "Sin datos",
    "origin": "Origen",
    "per_page": "por página",
    "type": "Tipo"
  }
}
</i18n>
