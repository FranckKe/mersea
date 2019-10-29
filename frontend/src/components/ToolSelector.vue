<template>
  <div class="tool-selector">
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
  </div>
</template>

<script>
import { createNamespacedHelpers } from 'vuex'
const toolBarModule = createNamespacedHelpers('toolBar')

export default {
  name: 'ToolSelector',
  props: ['toolButtonColorMod', 'toolComponent', 'toolTitle', 'toolIcon'],
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
    ...toolBarModule.mapActions(['toggleActiveComponent'])
  }
}
</script>

<style lang="scss">
.tool-selector {
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

@media only screen and (max-device-width: 1024px) {
  .tool-tab,
  .tool-selector {
    height: 100%;
    margin-top: 0;
  }

  .tool-selector {
    width: auto;
    min-width: 80px;

    &:first-of-type {
      margin-left: 0.25em;
    }
  }

  .tool-tab.button {
    height: 90%;
  }
}
</style>

