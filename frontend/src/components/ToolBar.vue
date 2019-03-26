<template>
  <div class="tool-bar">
    <Tool
      toolComponent="FilterReports"
      :toolTitle="$t('tracers')"
      :toolViewTitle="$t('filter_tracers_title')"
      toolIcon="filter"
      :class="{active: getActiveTool === 'FilterReports'}"
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
  width: 100px;
  max-width: 100px;
  min-width: 100px;
  background-color: white;
  z-index: 10;
}

.active {
  background-color: purple;
}

@media only screen and (max-device-width: 768px) {
  .tool-bar {
    width: calc(100% - 52px);
    min-width: calc(100% - 52px);
    max-width: calc(100% - 52px);
    height: 52px;
    margin-left: 52px;
    align-items: flex-start;
    flex-direction: row;
  }
}
</style>

<i18n>
{
  "en": {
    "tracers": "Tracers",
    "filter_tracers_title": "Filter by tracers"
  },
  "fr": {
    "tracers": "Tracers",
    "filter_tracers_title": "Filtrer par tracers"
  },
  "es": {
    "tracers": "Trazadores",
    "filter_tracers_title": "Filtrar por trazadores"
  }
}
</i18n>
