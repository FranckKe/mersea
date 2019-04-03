<template>
  <div class="lang-switcher">
    <b-select v-model="lang">
      <option
        v-for="(language, i) in getAvailableLangs()"
        :key="`language${i}`"
        :value="language"
        >{{ $t(language) }}</option
      >
    </b-select>
  </div>
</template>

<script>
import { mapState, mapGetters, mapActions } from 'vuex'

export default {
  name: 'langSwitcher',
  data() {
    return {}
  },
  methods: {
    ...mapGetters(['getAvailableLangs', 'getLang']),
    ...mapActions(['setLocale'])
  },
  computed: {
    ...mapState({
      lang: state => state.lang
    }),
    lang: {
      set(lang) {
        this.setLocale(lang)
      },
      get() {
        return this.getLang()
      }
    }
  }
}
</script>

<style scoped>
.lang-switcher {
  align-self: center;
  padding: 0.5rem 0.75rem;
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
