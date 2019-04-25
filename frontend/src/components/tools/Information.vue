<template>
  <div class="tool-information" v-html="this.toolContent"></div>
</template>

<script>
import { createNamespacedHelpers } from 'vuex'
const { mapGetters } = createNamespacedHelpers('pages')

export default {
  name: 'Information',
  data() {
    return {
      isActive: true,
      toolContent: ''
    }
  },
  created() {
    this.getContent()
  },
  computed: { ...mapGetters(['getPageContent']) },
  methods: {
    getContent: function() {
      this.toolContent = this.getPageContent({
        pageName: `ocean-plastic-tracker-${this.$i18n.locale}`
      })
    }
  },
  watch: {
    '$i18n.locale': function() {
      this.getContent()
    }
  }
}
</script>

<style lang="scss">
.tool-information {
  p {
    margin-bottom: 1rem;
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
