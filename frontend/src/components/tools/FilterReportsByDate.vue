<template>
  <div class="daterange">
    <b-field :label="$t('from')">
      <b-datepicker
        v-model="reported_at_min"
        icon="calendar"
      ></b-datepicker>
    </b-field>
    <b-field :label="$t('until')">
      <b-datepicker
        v-model="reported_at_max"
        icon="calendar"
      ></b-datepicker>
    </b-field>
  </div>
</template>

<script>
import { createNamespacedHelpers } from 'vuex'
import moment from 'moment'
const reportsModule = createNamespacedHelpers('reports')

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
  computed: {},
  methods: {
    ...reportsModule.mapActions(['loadReports'])
  },
  watch: {
    reported_at_min: function() {
      this.loadReports({
        reported_at_min: moment(this.reported_at_min).format('YYYY-MM-DD'),
        reported_at_max: moment(this.reported_at_max).format('YYYY-MM-DD')
      })
    },
    reported_at_max: function() {
      this.loadReports({
        reported_at_min: moment(this.reported_at_min).format('YYYY-MM-DD'),
        reported_at_max: moment(this.reported_at_max).format('YYYY-MM-DD')
      })
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
    "by_date": "By date"
  },
  "fr": {
    "from": "De",
    "until": "Jusqu'à",
    "by_date": "Rechercher"
  },
  "es": {
    "from": "Desde",
    "until": "Hasta",
    "by_date": "Por fecha"
  }
}
</i18n>
