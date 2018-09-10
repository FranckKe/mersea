import Vue from 'vue'
import Vuex from 'vuex'
import pages from './modules/pages'
import reports from './modules/reports'
import tracers from './modules/tracers'
import createPersistedState from 'vuex-persistedstate'
import i18n from '../i18n'

Vue.use(Vuex)

const store = new Vuex.Store({
  plugins: [createPersistedState()],
  modules: {
    pages: pages,
    reports: reports,
    tracers: tracers
  },
  state: {
    lang: 'fr',
    availableLangs: ['fr', 'en', 'es']
  },
  getters: {
    getAvailableLangs: state => {
      return state.availableLangs
    },
    getLang: state => {
      return state.lang
    }
  },
  mutations: {
    setLang: (state, { lang }) => {
      state.lang = lang
    }
  },
  actions: {
    setLocale: (context, lang) => {
      context.commit('setLang', { lang })
      i18n.locale = lang
    }
  }
})

store.dispatch('pages/loadPages')
store.dispatch('reports/loadReports')
store.dispatch('tracers/loadTracers')

export default store
