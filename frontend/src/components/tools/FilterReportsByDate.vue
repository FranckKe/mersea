<template>
  <div>
    <div class="title-wrapper">
      <h4 class="title is-4">{{ $t('filter_reports_by_date_title') }}</h4>
      <a @click="closeToolbar" class="button is-danger close-tool-button">
        <font-awesome-icon icon="times" />
      </a>
    </div>
    <div class="daterange">
      <b-loading
        :is-full-page="false"
        :active.sync="this.getLoading()"
        :can-cancel="false"
      ></b-loading>
      <h5 class="title is-5">{{ $t('quick_selection') }}</h5>
      <div class="buttons first-row">
        <button
          class="button is-primary"
          :class="{ 'is-active': isReportedAtEqualTo(startOfRange('week')) }"
          @click="setReportedAt(startOfRange('week'))"
        >
          <span>{{ $t('this_week') }}</span>
        </button>
        <button
          class="button is-primary"
          :class="{ 'is-active': isReportedAtEqualTo(startOfRange('month')) }"
          @click="setReportedAt(startOfRange('month'))"
        >
          <span>{{ $t('this_month') }}</span>
        </button>
      </div>
      <div class="buttons">
        <button
          v-for="years in [0, 1, 2, 3]"
          :key="years"
          class="button is-primary"
          :class="{
            'is-active': isReportedAtEqualTo(previousYearRange(years))
          }"
          @click="setReportedAt(previousYearRange(years))"
        >
          <span>{{ previousYearLabel(years) }}</span>
        </button>
      </div>
      <div class="buttons last">
        <button
          class="button is-primary"
          :class="{
            'is-active': isReportedAtEqualTo({
              min: new Date('2016-01-01'),
              max: new Date()
            })
          }"
          @click="
            setReportedAt({ min: new Date('2016-01-01'), max: new Date() })
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
          :month-names="monthNames"
          :day-names="dayNames"
          :first-day-of-week="firstDayOfTheWeek"
          v-validate="fieldFromRules"
        ></b-datepicker>
      </b-field>
      <b-field :label="$t('until')">
        <b-datepicker
          v-model="reported_at_max"
          name="datepicker_until"
          icon="calendar"
          :min-date="new Date('2016-01-01')"
          :max-date="new Date()"
          :month-names="monthNames"
          :day-names="dayNames"
          :first-day-of-week="firstDayOfTheWeek"
          v-validate="'required'"
        >
          <button class="button is-primary" @click="date = new Date()">
            <b-icon icon="calendar"></b-icon>
            <span>Today</span>
          </button>
        </b-datepicker>
      </b-field>
    </div>
  </div>
</template>

<script>
import { createNamespacedHelpers } from 'vuex'
const reportsModule = createNamespacedHelpers('reports')
const toolBarModule = createNamespacedHelpers('toolBar')
import moment from 'moment'

export default {
  name: 'filterReportsByDate',
  data() {
    return {
      isActive: false,
      apiUrl: this.$apiUrl,
      reported_at_min: new Date(this.$reported_at_min),
      reported_at_max: new Date(this.$reported_at_max),
      monthNames: moment.months(),
      dayNames: moment.weekdaysShort(),
      firstDayOfTheWeek: this.$i18n.locale === 'en' ? 0 : 1,
      maxDate: new Date()
    }
  },
  async mounted() {
    moment.locale(this.$i18n.locale)
  },
  methods: {
    ...reportsModule.mapActions(['loadReports']),
    ...reportsModule.mapGetters(['getLoading']),
    ...toolBarModule.mapGetters(['getActiveTool']),
    ...toolBarModule.mapActions(['toggleActiveComponent', 'closeToolbar']),
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
    setReportedAt: function(range) {
      this.reported_at_min = range.min
      this.reported_at_max = range.max
    },
    getReportedAt: function() {
      return {
        min: this.reported_at_min,
        max: this.reported_at_max
      }
    },
    isReportedAtEqualTo: function(range) {
      function roundToDay(date) {
        return moment(date)
          .startOf('day')
          .valueOf()
      }
      return (
        roundToDay(range.min) === roundToDay(this.reported_at_min) &&
        roundToDay(range.max) === roundToDay(this.reported_at_max)
      )
    },
    startOfRange: function(typeOf) {
      return {
        min: moment()
          .startOf(typeOf)
          .toDate(),
        max: new Date()
      }
    },
    previousYearRange(yearsToGoBack) {
      const previousYear = moment().subtract(yearsToGoBack, 'years')
      return {
        min: previousYear.startOf('year').toDate(),
        max: previousYear.endOf('year').toDate()
      }
    },
    previousYearLabel(yearsToGoBack) {
      return moment()
        .subtract(yearsToGoBack, 'years')
        .format('YYYY')
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
    },
    '$i18n.locale': function() {
      moment.locale(this.$i18n.locale)
      this.monthNames = moment.months()
      this.dayNames = moment.weekdaysShort()
      this.firstDayOfTheWeek = this.$i18n.locale === 'en' ? 0 : 1
    }
  }
}
</script>

<style lang="scss" scoped>
.daterange {
  position: relative;
  margin-bottom: 1rem;
}

.title.is-5 {
  margin-bottom: 0.5em;
}

.buttons {
  margin-bottom: 0;
}

.buttons.last {
  margin-bottom: 1rem;
}
</style>

<style>
.daterange
  .dropdown
  .datepicker-header
  .pagination-list
  .field
  .control
  .select
  select {
  text-transform: capitalize;
}

.daterange .dropdown .datepicker-cell {
  text-transform: capitalize;
  padding: 0.5rem;
}
</style>

<i18n>
{
  "en": {
    "filter_reports_by_date_title": "Filter by date",
    "from": "From",
    "until": "Until",
    "quick_selection": "Quick selection",
    "this_week": "Week to date",
    "this_month": "Month to date",
    "from_beginning": "From the beginning",
    "custom_range": "Custom range",
    "load_reports_failure": "Fail to load reports",
    "by_date": "By date"
  },
  "fr": {
    "filter_reports_by_date_title": "Filtrer par date",
    "from": "Du",
    "until": "Jusqu'au",
    "quick_selection": "Sélection rapide",
    "this_week": "Cette semaine",
    "this_month": "Ce mois",
    "from_beginning": "Depuis le début",
    "custom_range": "Période personnalisée",
    "load_reports_failure": "Échec de chargement des rapports",
    "by_date": "Rechercher"
  },
  "es": {
    "filter_reports_by_date_title": "Filtrar por fecha",
    "from": "Desde",
    "until": "Hasta",
    "quick_selection": "Selección rápida",
    "this_week": "Esta semana",
    "this_month": "Este mes",
    "from_beginning": "Desde el principio",
    "custom_range": "Rango personalizado",
    "load_reports_failure": "Fallo al cargar informes",
    "by_date": "Por fecha"
  }
}
</i18n>
