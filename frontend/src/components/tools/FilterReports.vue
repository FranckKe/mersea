<template>
  <div class="filter-reports">
    <div class="filter-reports-tool" v-on:click="toggleActive" :class="{active: isActive}">
      <font-awesome-icon icon="filter"/>
      <p>{{ $t('filter_reports') }}</p>
    </div>
    <div class="filter-reports-view" v-if="isActive">
      <div class="title-wrapper">
        <h4 class="title is-4">{{ $t('tracers') }}</h4>
        <a @click="toggleActive" class="button is-danger close-filter-button">
          <font-awesome-icon icon="times"/>
        </a>
      </div>
      <div class="control is-flex">
        <input
          class="input filter-report-search"
          v-model="search"
          type="search"
          v-bind:placeholder="$t('search')"
        >
      </div>
      <div class="check-buttons">
        <button type="submit" class="button" @click="checkAll">{{ $t('check_all') }}</button>
        <button type="submit" class="button" @click="unCheckAll">{{ $t('uncheck_all') }}</button>
      </div>
      <div class="legend-tracers">
        <div class="legend-tracer" :key="tracer.id" v-for="tracer in filteredTracersList">
          <b-checkbox v-model="filteredTracers" :native-value="tracer.id">
            <svg class="legend-circle" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
              <circle cx="10" cy="10" r="7" stroke="white" stroke-width="2.5" :fill="tracer.color"></circle>
            </svg>
            {{ tracer.name }} ({{ getReportCount()(tracer.id) }})
          </b-checkbox>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { createNamespacedHelpers } from 'vuex'
const tracersModule = createNamespacedHelpers('tracers')
const reportsModule = createNamespacedHelpers('reports')

export default {
  name: 'filterReports',
  data() {
    return {
      isActive: false,
      apiUrl: this.$apiUrl,
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
    toggleActive: function() {
      this.isActive = !this.isActive
    },
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
.filter-reports-tool {
  display: flex;
  justify-content: space-around;
  align-items: center;
  padding: 0.5em;
  width: 100%;
  height: 50px;
  background-color: whitesmoke;
}
.filter-reports-tool:hover,
.filter-reports-tool.active {
  background-color: gainsboro;
}
.filter-reports {
  width: 100%;
  height: 50px;
  display: flex;
  justify-content: center;
  align-items: center;
}
.filter-reports:hover {
  cursor: pointer;
}
.filter-reports p {
  text-align: center;
  cursor: pointer;
}
.filter-reports-view {
  width: 350px;
  height: calc(100vh - 52px);
  position: fixed;
  top: 51px; /* Menu heigth */
  left: 100px; /* Tool bar width */
  background-color: whitesmoke;
  z-index: 11;
  padding: 10px;
  display: flex;
  flex-direction: column;
}
.title-wrapper {
  display: flex;
  justify-content: space-between;
  margin-bottom: 0.5em;
}
.filter-reports-view h4.title {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-bottom: 0;
}
.filter-report-search {
  margin: 0.5em 0;
}
.legend-tracers {
  overflow-y: scroll;
  flex-shrink: 999;
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
  .filter-reports-tool,
  .filter-reports {
    height: 100%;
  }
  .filter-reports {
    max-width: 80px;
  }
  .filter-reports-view {
    height: calc(100vh - 52px - 2em); /* - menu-height - margin */
    border-radius: 6px;
    width: 90%;
    top: calc(50% + 20px);
    left: 50%;
    transform: translate(-50%, -50%);
  }
  .close-filter-button {
    align-self: flex-end;
    display: inline-flex;
  }
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
    "filter_reports": "Filter reports",
    "search": "Search",
    "tracers": "Tracers",
    "uncheck_all": "Uncheck all"
  },
  "fr": {
    "check_all": "Tout cocher",
    "filter_reports": "Filtrer",
    "search": "Rechercher",
    "tracers": "Tracers",
    "uncheck_all": "Tout décocher"
  },
  "es": {
    "check_all": "Comprobar todo",
    "filter_reports": "Filtro",
    "search": "Buscar",
    "tracers": "Trazadores",
    "uncheck_all": "Desmarcar todo"
  }
}
</i18n>
