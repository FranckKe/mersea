<template>
  <section class="section">
    <div class="container">
      <h1 class="title is-1">{{ $t('my_reports') }}</h1>

      <b-field grouped group-multiline>
        <b-select v-model="perPage">
          <option value="5">5 {{ $t('per_page') }}</option>
          <option value="10">10 {{ $t('per_page') }}</option>
          <option value="15">15 {{ $t('per_page') }}</option>
          <option value="20">20 {{ $t('per_page') }}</option>
        </b-select>

        <div class="control is-flex">
          <input
            class="input"
            v-model="filter"
            type="search"
            v-bind:placeholder="$t('search')"
          />
        </div>
      </b-field>

      <b-table
        :data="filtered"
        :paginated="true"
        :per-page="perPage"
        :current-page.sync="currentPage"
        :pagination-simple="false"
        :default-sort-direction="defaultSortDirection"
        default-sort="reported_at"
        striped
      >
        <template slot-scope="props">
          <b-table-column
            field="tracer"
            v-bind:label="$t('tracer')"
            width="40"
            sortable
            >{{ props.row.tracer }}</b-table-column
          >

          <b-table-column
            field="quantity"
            v-bind:label="$t('quantity')"
            sortable
            centered
            width="20"
            >{{ props.row.quantity }}</b-table-column
          >

          <b-table-column
            field="reported_at"
            v-bind:label="$t('reported_at')"
            sortable
            centered
            width="125"
            >{{ props.row.reported_at | formatDate }}</b-table-column
          >

          <b-table-column
            field="address"
            v-bind:label="$t('address')"
            sortable
            centered
            >{{ props.row.address }}</b-table-column
          >

          <b-table-column
            field="status"
            v-bind:label="$t('status')"
            sortable
            centered
            >{{ props.row.status | capitalize }}</b-table-column
          >
        </template>
      </b-table>
    </div>
  </section>
</template>

<script>
import moment from 'moment'

export default {
  data() {
    return {
      filter: '',
      defaultSortDirection: 'desc',
      currentPage: 1,
      perPage: 10,
      myReports: []
    }
  },
  async mounted() {
    try {
      let myReportsRes = await this.$http.get(
        `/reports?user_id=${this.$auth.user().id}`
      )
      this.myReports = myReportsRes.data
    } catch (e) {
      throw e
    }
  },
  computed: {
    filtered: function() {
      return this.myReports.filter(v => {
        let normalizedFilter = this.$normalizeStr(this.filter)
        return (
          this.$normalizeStr(v.tracer).includes(normalizedFilter) ||
          this.$normalizeStr(v.address).includes(normalizedFilter) ||
          this.$normalizeStr(v.status).includes(normalizedFilter) ||
          this.$normalizeStr(v.quantity.toString()).includes(
            normalizedFilter
          ) ||
          this.$normalizeStr(
            this.$options.filters.formatDate(v.reported_at)
          ).includes(normalizedFilter)
        )
      })
    }
  },
  watch: {
    '$i18n.locale': function() {
      moment.locale(this.$i18n.locale)
    }
  }
}
</script>

<style scoped></style>

<i18n>
{
  "en": {
    "tracer": "Tracer",
    "my_reports": "My reports",
    "status": "Status",
    "address": "Address",
    "reported_at": "Reported at",
    "quantity": "Quantity",
    "per_page": "per page",
    "search": "Search"
  },
  "fr": {
    "tracer": "Traceur",
    "my_reports": "Mes signalements",
    "status": "Status",
    "address": "Adresse",
    "reported_at": "Témoigné le",
    "name": "Nom",
    "quantity": "Quantité",
    "per_page": "par page",
    "search": "Rechercher"
  },
  "es": {
    "tracer": "Trazador",
    "my_reports": "Mi testimonios",
    "status": "Estado",
    "address": "dirección",
    "reported_at": "Reportado en",
    "name": "Apellido",
    "quantity": "Cantidad",
    "per_page": "por página",
    "search": "Buscar"
  }
}
</i18n>
