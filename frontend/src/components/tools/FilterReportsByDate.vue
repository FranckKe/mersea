<template>
  <div class="daterange">
    <h5 class="title is-5">{{ $t('quick_selection') }}</h5>
    <div class="buttons">
      <button class="button is-primary" @click="startOfRange('week')">
        <span>{{ $t('this_week') }}</span>
      </button>
      <button class="button is-primary" @click="dateRange(1, 'weeks')">
        <span>{{ $t('last_7_days') }}</span>
      </button>
      <button class="button is-primary" @click="dateRange(30, 'days')">
        <span>{{ $t('last_30_days') }}</span>
      </button>
    </div>
    <div class="buttons">
      <button class="button is-primary" @click="startOfRange('month')">
        <span>{{ $t('this_month') }}</span>
      </button>
      <button class="button is-primary" @click="dateRange(6, 'months')">
        <span>{{ $t('last_6_months') }}</span>
      </button>
      <button class="button is-primary" @click="dateRange(12, 'months')">
        <span>{{ $t('last_12_months') }}</span>
      </button>
    </div>
    <div class="buttons">
      <button class="button is-primary" @click="startOfRange('year')">
        <span>{{ $t('this_year') }}</span>
      </button>
      <button class="button is-primary" @click="dateRange(2, 'years')">
        <span>{{ $t('last_2_years') }}</span>
      </button>
      <button class="button is-primary" @click="
          reported_at_min = new Date('2016-01-01')
          reported_at_max = new Date('2016-12-31')
        ">
        <span>2016</span>
      </button>
      <button class="button is-primary" @click="
          reported_at_min = new Date('2017-01-01')
          reported_at_max = new Date('2017-12-31')
        ">
        <span>2017</span>
      </button>
      <button class="button is-primary" @click="
          reported_at_min = new Date('2018-01-01')
          reported_at_max = new Date('2018-12-31')
        ">
        <span>2018</span>
      </button>
      <button
        class="button is-primary"
        @click="
          reported_at_min = new Date('2016-01-01')
          reported_at_max = new Date()
        "
      >
        <span>{{ $t('from_beginning') }}</span>
      </button>
    </div>
    <h5 class="title is-5">{{ $t('custom_range') }}</h5>
    <b-field :label="$t('from')">
      <b-datepicker
        v-model="reported_at_min"
        name="datepicker_from"
        icon="calendar"
        :min-date="new Date('2016-01-01')"
        :max-date="new Date()"
        v-validate="fieldFromRules"
      >
      </b-datepicker>
    </b-field>
    <b-field :label="$t('until')">
      <b-datepicker
        v-model="reported_at_max"
        name="datepicker_until"
        icon="calendar"
        :min-date="new Date('2016-01-01')"
        :max-date="new Date()"
        v-validate="'required'"
      >
        <button class="button is-primary" @click="date = new Date()">
          <b-icon icon="calendar"></b-icon>
          <span>Today</span>
        </button>
      </b-datepicker>
    </b-field>
    <button
        class="button is-primary"@click="startOfRange('year')">
        <span>Reset</span>
    </button>
  </div>
</template>

<script>
import { createNamespacedHelpers } from 'vuex'
const reportsModule = createNamespacedHelpers('reports')
import moment from 'moment'

export default {
  name: 'filterReportsByDate',
  data() {
    return {
      isActive: false,
      apiUrl: this.$apiUrl,
      reported_at_min: new Date(this.$reported_at_min),
      reported_at_max: new Date(this.$reported_at_max)
    }
  },
  methods: {
    ...reportsModule.mapActions(['loadReports']),
    updateReports: async function() {
      try {
        await this.loadReports({
          reported_at_min: moment(this.reported_at_min).format('YYYY-MM-DD'),
          reported_at_max: moment(this.reported_at_max).format('YYYY-MM-DD')
        })
      } catch (e) {
        this.$toast.open({
          message: this.$t('load_reports_failure'),
          duration: 5000,
          type: 'is-danger'
        })
      }
    },
    dateRange: function(numberToSubstract, typeOf) {
      this.reported_at_min = moment()
        .subtract(numberToSubstract, typeOf)
        .toDate()
      this.reported_at_max = new Date()
    },
    startOfRange: function(typeOf) {
      this.reported_at_min = moment()
        .startOf(typeOf)
        .toDate()
      this.reported_at_max = new Date()
    }
  },
  computed: {
    fieldFromRules() {
      return {
        required: true,
        date_between: ['2016-01-01', this.reported_at_max, true]
      }
    },
    fieldToRules() {
      return {
        required: true,
        date_between: ['2016-01-01', new Date(), true]
      }
    }
  },
  watch: {
    reported_at_min: function() {
      this.updateReports()
    },
    reported_at_max: function() {
      this.updateReports()
    }
  }
}
</script>

<style>
.daterange .title.is-5 {
  margin-bottom: 0.5em;
}
</style>

<i18n>
{
  "en": {
    "from": "From",
    "until": "Until",
    "quick_selection": "Quick selection",
    "this_week": "Week to date",
    "last_7_days": "Last 7 days",
    "last_30_days": "Last 30 days",
    "this_month": "Month to date",
    "last_6_months": "Last 6 months",
    "last_12_months": "Last 12 months",
    "this_year": "Year to date",
    "last_2_years": "Last 2 years",
    "from_beginning": "From the beginning",
    "custom_range": "Custom range",
    "load_reports_failure": "Fail to load reports",
    "by_date": "By date"
  },
  "fr": {
    "from": "De",
    "until": "Jusqu'à",
    "quick_selection": "Selection rapide",
    "this_week": "Cette semaine",
    "last_7_days": "7 derniers jours",
    "last_30_days": "30 derniers jours",
    "this_month": "Ce mois",
    "last_6_months": "6 derniers mois",
    "last_12_months": "12 derniers mois",
    "this_year": "Cette année",
    "last_2_years": "2 dernières années",
    "from_beginning": "Depuis le début",
    "custom_range": "Période personnalisée",
    "load_reports_failure": "Échec de chargement des raports",
    "by_date": "Rechercher"
  },
  "es": {
    "from": "Desde",
    "until": "Hasta",
    "quick_selection": "Selección rápida",
    "this_week": "Esta semana",
    "last_7_days": "Últimos 7 días",
    "last_30_days": "Últimos 30 días",
    "this_month": "Este mes",
    "last_6_months": "Últimos 7 meses",
    "last_12_months": "Últimos 12 meses",
    "this_year": "Este año",
    "last_2_years": "últimos 2 años",
    "from_beginning": "Desde el principio",
    "custom_range": "Rango personalizado",
    "load_reports_failure": "Fallo al cargar informes",
    "by_date": "Por fecha"
  }
}
</i18n>
