<template>
  <div class="tool">
    <div
      class="tool-tab"
      @click="toggleActiveComponent(toolComponent)"
      :class="{ active: isActive }"
    >
      <font-awesome-icon :icon="toolIcon" />
      <p>{{ toolTitle }}</p>
    </div>
    <div class="tool-view" v-if="isActive">
      <div class="title-wrapper">
        <h4 class="title is-4">{{ toolViewTitle }}</h4>
        <a
          @click="toggleActiveComponent(toolComponent)"
          class="button is-danger close-tool-button"
        >
          <font-awesome-icon icon="times" />
        </a>
      </div>
      <component :is="toolComponent"></component>
    </div>
  </div>
</template>

<script>
import { createNamespacedHelpers } from 'vuex'
import FilterReportsByTracer from '@/components/tools/FilterReportsByTracer'
import FilterReportsByDate from '@/components/tools/FilterReportsByDate'
const toolBarModule = createNamespacedHelpers('toolBar')

export default {
  name: 'Tool',
  props: ['toolComponent', 'toolTitle', 'toolViewTitle', 'toolIcon'],
  components: {
    FilterReportsByTracer,
    FilterReportsByDate
  },
  data() {
    return {}
  },
  computed: {
    isActive: function() {
      return this.getActiveTool() === this.toolComponent
    }
  },
  methods: {
    ...toolBarModule.mapGetters(['getActiveTool']),
    ...toolBarModule.mapMutations(['setActiveTool']),
    ...toolBarModule.mapActions(['toggleActiveComponent'])
  }
}
</script>

<style>
.tool-tab {
  display: flex;
  justify-content: flex-start;
  align-items: center;
  padding: 0.5em;
  width: 100%;
  height: 50px;
  background-color: whitesmoke;
}
.tool-tab:hover,
.tool-tab.active {
  background-color: gainsboro;
}
.tool {
  width: 100%;
  height: 50px;
  display: flex;
  justify-content: center;
  align-items: center;
}
.tool:hover {
  cursor: pointer;
}
.tool p {
  text-align: center;
  margin-left: 0.25em;
  cursor: pointer;
}
.tool-view {
  width: 362px;
  height: calc(100vh - 55px);
  position: fixed;
  top: 52px; /* Menu heigth */
  left: 124px; /* Tool bar width */
  background-color: whitesmoke;
  z-index: 11;
  padding: 10px;
  display: flex;
  flex-direction: column;
  overflow-y: scroll;
}

.title-wrapper {
  display: flex;
  justify-content: space-between;
  margin-bottom: 0.5em;
  min-height: 36px;
}
.tool-view h4.title {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-bottom: 0;
}
.close-tool-button {
  display: none;
}

@media only screen and (max-device-width: 768px) {
  .tool-tab,
  .tool {
    height: 100%;
  }
  .tool {
    width: auto;
  }
  .tool-view {
    height: calc(100vh - 51px - 2em); /* - menu-height - margin */
    border-radius: 6px;
    width: 90%;
    top: calc(50% + 20px);
    left: 50%;
    transform: translate(-50%, -50%);
  }
  .close-tool-button {
    align-self: flex-end;
    display: inline-flex;
  }
}
</style>

<i18n>
{
  "en": {
  },
  "fr": {
  },
  "es": {
  }
}
</i18n>
