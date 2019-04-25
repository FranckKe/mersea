import Vue from 'vue'
import Vuex from 'vuex'
import addReport from './modules/addReport'
import pages from './modules/pages'
import reports from './modules/reports'
import toolBar from './modules/toolBar'
import tracers from './modules/tracers'
import createPersistedState from 'vuex-persistedstate'
import i18n from '../i18n'

Vue.use(Vuex)

const store = new Vuex.Store({
  plugins: [
    createPersistedState({
      // Do not persist the active state of the AddReport modal
      filter: mutation => !['addReport/setIsFormActive'].includes(mutation.type)
    })
  ],
  modules: {
    addReport: addReport,
    pages: pages,
    reports: reports,
    toolBar: toolBar,
    tracers: tracers
  },
  state: {
    lang: i18n.locale,
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

export default store
