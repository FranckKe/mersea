<template>
  <div class="tool-bar">
    <Tool
      toolComponent="Information"
      :toolTitle="$t('information')"
      toolViewTitle="Ocean Plastic Tracker"
      toolIcon="info-circle"
      :class="{ active: getActiveTool === 'FilterReportsByTracer' }"
    ></Tool>
    <p class="filter-by">
      <span class="icon"> <font-awesome-icon icon="filter" /> </span
      >{{ $t('filter_by') }}
    </p>
    <Tool
      toolComponent="FilterReportsByTracer"
      :toolTitle="$t('tracers')"
      :toolViewTitle="$t('filter_reports_by_tracer_title')"
      toolIcon="filter"
      :class="{ active: getActiveTool === 'FilterReportsByTracer' }"
    ></Tool>
    <Tool
      toolComponent="FilterReportsByDate"
      :toolTitle="$t('date')"
      :toolViewTitle="$t('filter_reports_by_date_title')"
      toolIcon="filter"
      :class="{ active: getActiveTool === 'FilterReportsByDate' }"
    ></Tool>
  </div>
</template>

<script>
import { createNamespacedHelpers } from 'vuex'
import Tool from '@/components/Tool'
const toolBarModule = createNamespacedHelpers('toolBar')

export default {
  name: 'ToolBar',
  components: {
    Tool
  },
  data() {
    return {
      currentTool: ''
    }
  },
  methods: {
    ...toolBarModule.mapGetters(['getActiveTool']),
    ...toolBarModule.mapMutations(['setActiveTool']),
    ...toolBarModule.mapActions(['toggleActiveComponent'])
  }
}
</script>

<style scoped>
.tool-bar {
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  align-items: center;
  width: 125px;
  max-width: 125px;
  min-width: 125px;
  background-color: white;
  z-index: 10;
  position: fixed;
  height: calc(100vh - 50px);
}

.active {
  background-color: purple;
}

p {
  width: 100%;
  display: flex;
  justify-content: flex-start;
  align-items: center;
  margin: 0.5rem 0;
}

@media only screen and (max-device-width: 1024px) {
  .tool-bar {
    width: calc(100% - var(--header-height));
    min-width: calc(100% - var(--header-height));
    max-width: calc(100% - var(--header-height));
    height: var(--header-height);
    margin-left: var(--header-height);
    align-items: flex-start;
    flex-direction: row;
    overflow: scroll;
  }

  .filter-by {
    display: none;
  }
}
</style>

<i18n>
{
  "en": {
    "tracers": "Tracers",
    "information": "Information",
    "filter_by": "Filter by",
    "filter_reports_by_tracer_title": "Filter by tracers",
    "date": "Date",
    "filter_reports_by_date_title": "Filter by date"
  },
  "fr": {
    "tracers": "Traceurs",
    "information": "Information",
    "filter_by": "Filtrer par",
    "filter_reports_by_tracer_title": "Filtrer par traceurs",
    "date": "Date",
    "filter_reports_by_date_title": "Filtrer par date"
  },
  "es": {
    "tracers": "Trazadores",
    "information": "Información",
    "filter_by": "Filtrado por",
    "filter_reports_by_tracer_title": "Filtrar por trazadores",
    "date": "Fecha",
    "filter_reports_by_date_title": "Filtrar por fecha"
  }
}
</i18n>
