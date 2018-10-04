<template>
  <section class="section">
    <div class="container">
      <h1 class="title is-1">{{ $t('contributions') }}</h1>

      <b-field grouped group-multiline>
      <b-select v-model="perPage">
        <option value="5">5 {{ $t('per_page') }}</option>
        <option value="10">10 {{ $t('per_page') }}</option>
        <option value="15">15 {{ $t('per_page') }}</option>
        <option value="20">20 {{ $t('per_page') }}</option>
      </b-select>

        <div class="control is-flex">
          <input class="input" v-model="filter" type="search" v-bind:placeholder="$t('search')">
        </div>
      </b-field>

      <b-table
      :data="filtered"
      :paginated="true"
      :per-page="perPage"
      :current-page.sync="currentPage"
      :pagination-simple="false"
      :default-sort-direction="defaultSortDirection"
      default-sort="name">

      <template slot-scope="props">
        <b-table-column field="name" v-bind:label="$t('name')" width="40" sortable numeric>
          {{ props.row.name }}
        </b-table-column>

        <b-table-column field="reports_count" v-bind:label="$t('number_of_reports')" sortable>
          {{ props.row.reports_count }}
        </b-table-column>

        <b-table-column field="last_activity" v-bind:label="$t('last_activity')" sortable centered>
          {{ props.row.last_activity }}
        </b-table-column>
      </template>
    </b-table>
  </div>
</section>
</template>

<script>
export default {
  data() {
    return {
      leaderboard: [],
      filter: '',
      defaultSortDirection: 'asc',
      currentPage: 1,
      perPage: 10
    }
  },
  mounted() {
    this.load()
  },
  methods: {
    load: async function() {
      try {
        let leaderboard = await this.$http.get(`/leaderboard`)
        this.leaderboard = leaderboard.data
      } catch (e) {
        throw e
      }
    }
  },
  computed: {
    filtered: function() {
      return this.leaderboard.filter(v => {
        return (
          v.name.toLowerCase().includes(this.filter.toLowerCase()) ||
          v.reports_count.toString().includes(this.filter.toLowerCase()) ||
          v.last_activity.includes(this.filter.toLowerCase())
        )
      })
    }
  }
}
</script>

<style>
</style>

<i18n>
{
  "en": {
    "contributions": "Contributions",
    "last_activity": "Last activity",
    "name": "Name",
    "number_of_reports": "Number of reports",
    "per_page": "per page",
    "search": "Search"
  },
  "fr": {
    "contributions": "Contributions",
    "last_activity": "Dernière activité",
    "name": "Nom",
    "number_of_reports": "Nombre de témoignages",
    "per_page": "par page",
    "search": "Rechercher"
  },
  "es": {
    "contributions": "Contribución",
    "last_activity": "Última actividad",
    "name": "Apellido",
    "number_of_reports": "número de testimonios",
    "per_page": "por página",
    "search": "Buscar"
  }
}
</i18n>
