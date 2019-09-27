<template>
  <div class="tool">
    <a
      class="tool-tab button"
      :class="[isActive ? 'is-active' : '', toolButtonColorMod]"
      @click="toggleActiveComponent(toolComponent)"
    >
      <span v-if="toolIcon !== ''" class="icon is-small">
        <font-awesome-icon :icon="toolIcon" />
      </span>
      <span class="tool-title">{{ toolTitle }}</span>
    </a>
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
      <keep-alive>
        <component :is="toolComponent"></component>
      </keep-alive>
    </div>
  </div>
</template>

<script>
import { createNamespacedHelpers } from 'vuex'
import FilterReportsByTracer from '@/components/tools/FilterReportsByTracer'
import AddReport from '@/components/tools/AddReport'
import FilterReportsByDate from '@/components/tools/FilterReportsByDate'
import Information from '@/components/tools/Information'
const toolBarModule = createNamespacedHelpers('toolBar')

export default {
  name: 'Tool',
  props: [
    'toolButtonColorMod',
    'toolComponent',
    'toolTitle',
    'toolViewTitle',
    'toolIcon'
  ],
  components: {
    AddReport,
    Information,
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

<style lang="scss">
.tool {
  width: 100%;
  height: 60px;
  display: flex;
  justify-content: center;
  align-items: center;
}

.tool-tab.button {
  width: 95%;
  height: 90%;
  border-radius: 3px;
  flex-direction: column;
}

.tool-tab.button .icon {
  margin: 0 !important; // Override font-awesome style to properly center icon
}

.tool-title {
  align-items: center;
  justify-content: center;
}

.tool-view {
  width: 420px;
  height: calc(100vh - 55px);
  position: fixed;
  top: 56px; /* Menu heigth */
  left: 100px; /* Tool bar width */
  background-color: white;
  z-index: 11;
  padding: 10px;
  display: flex;
  flex-direction: column;
  overflow-y: auto;
  max-width: 550px;
  margin: auto;
}

.title-wrapper {
  display: flex;
  justify-content: space-between;
  margin-bottom: 0.5em;
}

.tool-view h4.title {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-bottom: 0;
}

@media only screen and (max-device-width: 1024px) {
  .tool-tab,
  .tool {
    height: 100%;
    margin-top: 0;
  }

  .tool {
    width: auto;
    min-width: 80px;

    &:first-of-type {
      margin-left: 0.25em;
    }
  }

  .tool-tab.button {
    height: 90%;
  }

  .tool-view {
    width: 100%;
    left: 0;
    top: 50vh;
    height: 50vh;
    max-width: 100%;
    padding: 15px;
  }

  .close-tool-button {
    align-self: center;
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
