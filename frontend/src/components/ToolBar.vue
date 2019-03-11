<template>
  <div class="tool-bar">
    <FilterReports></FilterReports>
  </div>
</template>

<script>
import { mapState, mapGetters, mapActions } from 'vuex'
import FilterReports from '@/components/tools/FilterReports'

export default {
  name: 'ToolBar',
  components: {
    FilterReports
  },
  data() {
    return {}
  },
  methods: {
    ...mapGetters(['']),
    ...mapActions([''])
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
  z-index: 30;
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
    "en": "English",
    "es": "Spañish",
    "fr": "Français"
  },
  "fr": {
    "en": "English",
    "es": "Spañish",
    "fr": "Français"
  },
  "es": {
    "en": "English",
    "es": "Spañish",
    "fr": "Français"
  }
}
</i18n>
