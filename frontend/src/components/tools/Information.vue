<template>
  <div class="welcome">
    <div class="title-wrapper">
      <h4 class="title is-4">Ocean Plastic Tracker</h4>
      <a @click="closeToolbar" class="button is-danger close-tool-button">
        <font-awesome-icon icon="times" />
      </a>
    </div>
    <b-loading
      :is-full-page="false"
      :active.sync="this.getLoading()"
      :can-cancel="false"
    ></b-loading>
    <div
      class="tool-information"
      v-html="
        this.getPageContent({
          pageName: `ocean-plastic-tracker-${this.$i18n.locale}`
        })
      "
    ></div>
  </div>
</template>

<script>
import { createNamespacedHelpers } from 'vuex'
const { mapGetters } = createNamespacedHelpers('pages')
const toolBarModule = createNamespacedHelpers('toolBar')

export default {
  name: 'Information',
  data() {
    return {
      isActive: true,
      toolContent: ''
    }
  },
  methods: {
    ...mapGetters(['getLoading']),
    ...toolBarModule.mapGetters(['getActiveTool']),
    ...toolBarModule.mapActions(['toggleActiveComponent', 'closeToolbar'])
  },
  computed: { ...mapGetters(['getPageContent']) }
}
</script>

<style lang="scss">
.welcome {
  position: relative;
  height: 100%;
}

.tool-information {
  padding: 1.25rem;
  p {
    margin-bottom: 1rem;

    span {
      font-size: 1rem !important; // override back office editor font-size
    }
  }

  h1,
  h2,
  h3,
  h4,
  h5,
  h6 {
    color: #363636;
    font-size: 2rem;
    font-weight: 600;
    line-height: 1.125;
    margin-bottom: 1rem;
  }
  h1 {
    font-size: 3rem;
  }
  h2 {
    font-size: 2.5rem;
  }
  h3 {
    font-size: 2rem;
  }
  h4 {
    font-size: 1.5rem;
  }
  h5 {
    font-size: 1.25rem;
  }
  h6 {
    font-size: 1rem;
  }
}
</style>

<i18n>
{
  "en": {
    "welcome": "Ocean plastic tracker"
  },
  "fr": {
    "welcome": "Bienvenue"
  },
  "es": {
    "welcome": "Comprobar todo"
  }
}
</i18n>
