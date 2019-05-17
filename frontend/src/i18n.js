import Vue from 'vue'
import VueI18n from 'vue-i18n'

Vue.use(VueI18n)

function loadLocaleMessages() {
  const locales = require.context(
    './locales',
    true,
    /[A-Za-z0-9-_,\s]+\.json$/i
  )
  const messages = {}
  locales.keys().forEach(key => {
    const matched = key.match(/([a-z0-9]+)\./i)
    if (matched && matched.length > 1) {
      const locale = matched[1]
      messages[locale] = locales(key)
    }
  })
  return messages
}

// Detect browser language and strip the "region" language
// en-GB => en
let browserI18n = navigator.language
if (navigator.language.indexOf('-') >= 0)
  browserI18n = navigator.language.substring(0, navigator.language.indexOf('-'))

// Default to english if browser language is not supported
let initializedLocal = ['en', 'es', 'fr'].includes(browserI18n)
  ? browserI18n
  : 'en'

export default new VueI18n({
  locale: initializedLocal,
  fallbackLocale: 'en',
  messages: loadLocaleMessages()
})
