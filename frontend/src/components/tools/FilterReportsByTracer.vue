<template>
  <div>
    <div class="control is-flex">
      <input
        class="input filter-report-search"
        v-model="search"
        type="search"
        v-bind:placeholder="$t('search')"
      />
    </div>
    <div class="check-buttons">
      <button type="submit" class="button" @click="checkAll">
        {{ $t('check_all') }}
      </button>
      <button type="submit" class="button" @click="unCheckAll">
        {{ $t('uncheck_all') }}
      </button>
    </div>
    <div class="legend-tracers">
      <div
        class="legend-tracer"
        :key="tracer.id"
        v-for="tracer in filteredTracersList"
      >
        <b-checkbox v-model="filteredTracers" :native-value="tracer.id">
          <svg
            class="legend-circle"
            viewBox="0 0 20 20"
            xmlns="http://www.w3.org/2000/svg"
          >
            <circle
              cx="10"
              cy="10"
              r="7"
              stroke="white"
              stroke-width="2.5"
              :fill="tracer.color"
            ></circle>
          </svg>
          {{ tracer.name }} ({{ getReportCount()(tracer.id) }})
        </b-checkbox>
      </div>
    </div>
  </div>
</template>

<script>
import { createNamespacedHelpers } from 'vuex'
const tracersModule = createNamespacedHelpers('tracers')
const reportsModule = createNamespacedHelpers('reports')

export default {
  name: 'filterReportsByTracer',
  data() {
    return {
      isActive: false,
      apiUrl: this.$apiUrl,
      reported_at_min: new Date(this.$reported_at_min),
      reported_at_max: new Date(this.$reported_at_max),
      search: ''
    }
  },
  computed: {
    ...tracersModule.mapState({
      tracers: state => state.tracers,
      filteredTracers: state => state.filteredTracers
    }),
    filteredTracers: {
      set(value) {
        this.setFilteredTracers(value)
      },
      get() {
        return this.getFilteredTracers()
      }
    },
    filteredTracersList: function() {
      return this.tracers.filter(t => {
        return t.name.toLowerCase().includes(this.search.toLowerCase())
      })
    }
  },
  methods: {
    ...reportsModule.mapGetters(['getReportCount']),
    ...tracersModule.mapGetters(['getTracers', 'getFilteredTracers']),
    ...tracersModule.mapMutations(['setFilteredTracers']),
    checkAll: function() {
      this.setFilteredTracers(this.tracers.map(t => t.id))
    },
    unCheckAll: function() {
      this.setFilteredTracers([])
    }
  }
}
</script>

<style>
.filter-report-search {
  margin: 0.5em 0;
}
.legend-tracers {
  margin-bottom: 1.5em;
}
.legend-tracer {
  width: 100%;
  display: flex;
  align-items: center;
  padding-left: 0.5em;
  flex-direction: column;
  min-height: 25px;
}
.legend-tracer:hover {
  background-color: gainsboro;
}
.legend-tracer label {
  width: 100%;
  display: flex;
  height: 35px;
}
.legend-tracer .control-label {
  width: 100%;
  display: flex;
  align-items: center;
  flex-direction: row;
  text-transform: capitalize;
}
.legend-circle {
  width: 20px;
  height: 20px;
  display: flex;
  justify-content: center;
  align-items: center;
  margin-right: 0.5em;
}
.check-buttons {
  display: flex;
  align-items: center;
  margin-bottom: 0.5em;
  margin-top: -0.5em; /* Get margin only when elements are wrapped */
}

.check-buttons button {
  margin-top: 0.5em; /* Get margin only when elements are wrapped */
}

.check-buttons button:first-child {
  margin-right: 0.5em;
}
.close-filter-button {
  display: none;
}

@media only screen and (max-device-width: 768px) {
  .legend-tracer label {
    height: 30px;
  }
  .legend-tracer .control-label {
    font-size: 0.9em;
  }
}
</style>

<i18n>
{
  "en": {
    "check_all": "Check all",
    "search": "Search",
    "uncheck_all": "Uncheck all"
  },
  "fr": {
    "check_all": "Tout cocher",
    "search": "Rechercher",
    "uncheck_all": "Tout décocher"
  },
  "es": {
    "check_all": "Comprobar todo",
    "search": "Buscar",
    "uncheck_all": "Desmarcar todo"
  }
}
</i18n>
