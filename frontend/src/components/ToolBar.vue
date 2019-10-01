<template>
  <div class="tool-bar">
    <keep-alive>
      <Tool
        toolComponent="AddReport"
        :toolTitle="$t('add_report')"
        :toolViewTitle="$t('add_report_title')"
        toolIcon="plus"
        toolButtonColorMod="is-success"
        :class="{ active: getActiveTool === 'AddReport' }"
      ></Tool>
    </keep-alive>
    <keep-alive>
      <Tool
        toolComponent="Information"
        :toolTitle="$t('information')"
        toolViewTitle="Ocean Plastic Tracker"
        toolIcon="info-circle"
        toolButtonColorMod="is-primary"
        :class="{ active: getActiveTool === 'FilterReportsByTracer' }"
      ></Tool>
    </keep-alive>
    <keep-alive>
      <Tool
        toolComponent="FilterReportsByTracer"
        :toolTitle="$t('tracers')"
        :toolViewTitle="$t('filter_reports_by_tracer_title')"
        toolIcon="filter"
        toolButtonColorMod="is-primary"
        :class="{ active: getActiveTool === 'FilterReportsByTracer' }"
      ></Tool>
    </keep-alive>
    <keep-alive>
      <Tool
        toolComponent="FilterReportsByDate"
        :toolTitle="$t('date')"
        :toolViewTitle="$t('filter_reports_by_date_title')"
        toolIcon="filter"
        toolButtonColorMod="is-primary"
        :class="{ active: getActiveTool === 'FilterReportsByDate' }"
      ></Tool>
    </keep-alive>
  </div>
</template>

<script>
import { createNamespacedHelpers } from 'vuex'
import Tool from '@/components/Tool'
import Bowser from 'bowser'

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
  },
  mounted() {
    const browser = Bowser.getParser(window.navigator.userAgent)
    const isBrokenBrowser = browser.satisfies({
      safari: '>1'
    })
    // Tool display with overflow does not work on Safari
    // Todo refactor tools
    if (isBrokenBrowser) {
      document.querySelector('.tool-bar').style.overflow = 'visible'
    }
  }
}
</script>

<style scoped>
.tool-bar {
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  align-items: center;
  width: 100px;
  max-width: 100px;
  min-width: 100px;
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
    /* 56px = Header height. Not using css variables for old Safari support  */
    width: calc(100% - 56px);
    min-width: calc(100% - 56px);
    max-width: calc(100% - 56px);
    height: 56px;
    margin-left: 56px;
    align-items: flex-start;
    flex-direction: row;
    overflow: scroll;
    /* More than hamburger menu */
    z-index: 31;
  }
}
</style>

<i18n>
{
  "en": {
    "add_report": "Report",
    "add_report_title": "Report a waste",
    "tracers": "Tracers",
    "information": "Info",
    "filter_by": "Filter by",
    "filter_reports_by_tracer_title": "Filter by tracers",
    "date": "Date",
    "filter_reports_by_date_title": "Filter by date"
  },
  "fr": {
    "add_report": "Signaler",
    "add_report_title": "Signaler un déchet",
    "tracers": "Traceurs",
    "information": "Info",
    "filter_by": "Filtrer par",
    "filter_reports_by_tracer_title": "Filtrer par traceurs",
    "date": "Date",
    "filter_reports_by_date_title": "Filtrer par date"
  },
  "es": {
    "add_report": "Reportar",
    "add_report_title": "Reportar un desperdicio",
    "tracers": "Trazadores",
    "information": "Info",
    "filter_by": "Filtrado por",
    "filter_reports_by_tracer_title": "Filtrar por trazadores",
    "date": "Fecha",
    "filter_reports_by_date_title": "Filtrar por fecha"
  }
}
</i18n>
