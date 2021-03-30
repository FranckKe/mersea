<template>
  <div class="tool-bar">
    <keep-alive>
      <ToolSelector
        toolComponent="AddReport"
        :toolTitle="$t('add_report')"
        toolIcon="plus"
        toolButtonColorMod="is-success"
        :class="{ active: getActiveTool === 'AddReport' }"
      ></ToolSelector>
    </keep-alive>
    <keep-alive>
      <ToolSelector
        toolComponent="Information"
        :toolTitle="$t('information')"
        toolIcon="info-circle"
        toolButtonColorMod="is-primary"
        :class="{ active: getActiveTool === 'FilterReportsByTracer' }"
      ></ToolSelector>
    </keep-alive>
    <keep-alive>
      <ToolSelector
        toolComponent="FilterReportsByTracer"
        :toolTitle="$t('tracers')"
        toolIcon="filter"
        toolButtonColorMod="is-primary"
        :class="{ active: getActiveTool === 'FilterReportsByTracer' }"
      ></ToolSelector>
    </keep-alive>
    <keep-alive>
      <ToolSelector
        toolComponent="FilterReportsByDate"
        :toolTitle="$t('date')"
        toolIcon="filter"
        toolButtonColorMod="is-primary"
        :class="{ active: getActiveTool === 'FilterReportsByDate' }"
      ></ToolSelector>
    </keep-alive>
  </div>
</template>

<script>
import { createNamespacedHelpers } from 'vuex'
import ToolSelector from '@/components/ToolSelector'

const toolBarModule = createNamespacedHelpers('toolBar')

export default {
  name: 'ToolBar',
  components: {
    ToolSelector
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
    "date": "Date",
    "filter_by": "Filter by",
    "information": "Info",
    "tracers": "Tracers"
  },
  "fr": {
    "add_report": "Signaler",
    "date": "Date",
    "filter_by": "Filtrer par",
    "information": "Info",
    "tracers": "Traceurs"
  },
  "es": {
    "add_report": "Reportar",
    "date": "Fecha",
    "filter_by": "Filtrado por",
    "information": "Info",
    "tracers": "Trazadores"
  }
}
</i18n>
