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
      <button type="submit" class="button is-primary" @click="checkAll">
        {{ $t('check_all') }}
      </button>
      <button type="submit" class="button is-primary" @click="unCheckAll">
        {{ $t('uncheck_all') }}
      </button>
    </div>
    <div class="legend-tracers">
      <b-loading
        :is-full-page="false"
        :active.sync="this.getLoading() || this.getReportsLoading()"
        :can-cancel="false"
      ></b-loading>
      <div
        class="legend-category-tracer"
        :key="tracersByCategory.category"
        v-for="tracersByCategory in allFilteredTracersList"
      >
        <h3 class="title is-6">{{ $t(tracersByCategory.category) }}</h3>
        <div
          class="legend-tracer"
          :key="tracer.id"
          v-for="tracer in tracersByCategory.tracers"
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
      <p class="has-text-left is-italic">
        {{ this.filteredTracersList.length }}
        {{ $tc('tracers', this.filteredTracersList.length) }}
        {{ $tc('displayed', this.filteredTracersList.length) }}
        ({{ this.tracers.length }} {{ $t('total') }})
      </p>
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
        return (
          this.$normalizeStr(t.name).includes(
            this.$normalizeStr(this.search)
          ) && this.getReportCount()(t.id) > 0
        )
      })
    },
    allFilteredTracersList: function() {
      let allFilteredTracersByCategory = []
      let categories = [
        ...new Set(this.filteredTracersList.map(tracer => tracer.category))
      ].sort()
      // Put archived in last position
      if (categories[0] === 'archive') categories.shift()
      categories.push('archive')

      categories.map(category => {
        allFilteredTracersByCategory.push({
          category: category,
          tracers: this.filteredTracersList.filter(
            tracer => category === tracer.category
          )
        })
      })

      return allFilteredTracersByCategory
    }
  },
  methods: {
    ...reportsModule.mapGetters({
      getReportCount: 'getReportCount',
      getReportsLoading: 'getLoading'
    }),
    ...tracersModule.mapGetters([
      'getTracers',
      'getFilteredTracers',
      'getAllFilteredTracersByCategory',
      'getLoading'
    ]),
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

<style lang="scss">
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

  &:hover {
    background-color: gainsboro;
  }

  label {
    width: 100%;
    display: flex;
    height: 35px;
    height: 100%;
    padding: 5px 0;
  }

  .control-label {
    width: 100%;
    display: flex;
    align-items: center;
    flex-direction: row;
    text-transform: capitalize;
  }
}

.legend-category-tracer {
  margin-top: 0.25rem;

  .title {
    margin-bottom: 0.25rem;
  }
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

@media only screen and (max-device-width: 1024px) {
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
    "tracers": "tracer | tracers",
    "check_all": "Check all",
    "search": "Search",
    "displayed": "displayed | displayed",
    "total": "total",
    "research": "Research",
    "drift": "Drift",
    "container": "Container",
    "archive": "Archive",
    "uncheck_all": "Uncheck all"
  },
  "fr": {
    "tracers": "traceur | traceurs",
    "check_all": "Tout cocher",
    "search": "Rechercher",
    "displayed": "affiché | affichés",
    "total": "en tout",
    "research": "Recherche",
    "drift": "Dérive",
    "container": "Conteneur",
    "archive": "Archive",
    "uncheck_all": "Tout décocher"
  },
  "es": {
    "tracers": "trazador | trazadores",
    "check_all": "Comprobar todo",
    "search": "Buscar",
    "displayed": "desplegado | desplegado",
    "total": "total",
    "research": "Búsqueda",
    "drift": "Dériva",
    "container": "Envase",
    "archive": "Archivo",
    "uncheck_all": "Desmarcar todo"
  }
}
</i18n>
