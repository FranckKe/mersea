<template>
  <div class="tool-view" v-if="this.getActiveTool().length > 0">
    <component :is="this.getActiveTool()"></component>
  </div>
</template>


<script>
import { createNamespacedHelpers } from 'vuex'
const toolBarModule = createNamespacedHelpers('toolBar')

// List of tools
import FilterReportsByTracer from '@/components/tools/FilterReportsByTracer'
import AddReport from '@/components/tools/AddReport'
import FilterReportsByDate from '@/components/tools/FilterReportsByDate'
import Information from '@/components/tools/Information'

export default {
  name: 'ToolView',
  components: {
    AddReport,
    Information,
    FilterReportsByTracer,
    FilterReportsByDate
  },
  data() {
    return {}
  },
  methods: {
    ...toolBarModule.mapGetters(['getActiveTool']),
    ...toolBarModule.mapMutations(['setActiveTool']),
    ...toolBarModule.mapActions(['toggleActiveComponent'])
  }
}
</script>

<style lang="scss">
.tool-view {
  width: 500px;
  // max-width: 550px;
  height: calc(100vh - 145px);
  min-height: calc(100vh - 145px);
  border-radius: 4px;
  position: fixed;
  top: 112px; /* Menu heigth + search bar height + margin */
  left: 110px; /* Tool bar width + margin */
  background-color: white;
  z-index: 11;
  padding: 10px;
  margin: 0;
  display: flex;
  flex-direction: column;
  overflow-y: auto;
  // margin: auto;
}

.title-wrapper {
  display: flex;
  justify-content: space-between;
  margin-bottom: 0.5em;
  height: 36px;
}

.tool-view h4.title {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-bottom: 0;
}

@media only screen and (max-device-width: 1024px) {
  .tool-view {
    position: relative;
    width: 100%;
    height: 33vh;
    max-height: 33vh;
    min-height: 33vh;
    left: 0;
    top: 0;
    overflow-y: initial;
  }

  .close-tool-button {
    align-self: center;
    display: inline-flex;
  }
}
</style>

