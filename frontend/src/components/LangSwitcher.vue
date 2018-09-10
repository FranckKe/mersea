<template>
<div class="lang-switcher">
  <b-select v-model="lang">
    <option v-for="(language, i) in getAvailableLangs()" :key="`language${i}`" :value="language">
      {{ $t(language) }}
    </option>
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

<style>
.lang-switcher {
  align-self: center;
}
</style>

<i18n>
{
  "en": {
    "fr": "Français",
    "en": "English",
    "es": "Spañish"
  },
  "fr": {
    "fr": "Français",
    "en": "English",
    "es": "Spañish"
  },
  "es": {
    "fr": "Français",
    "en": "English",
    "es": "Spañish"
  }
}
</i18n>
