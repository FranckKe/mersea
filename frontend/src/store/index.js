import Vue from 'vue'
import Vuex from 'vuex'
import pages from './modules/pages'
import reports from './modules/reports'
import tracers from './modules/tracers'
import createPersistedState from 'vuex-persistedstate'

Vue.use(Vuex)

const store = new Vuex.Store({
  plugins: [createPersistedState()],
  modules: {
    pages: pages,
    reports: reports,
    tracers: tracers
  },
  state: {},
  mutations: {},
  actions: {}
})

store.dispatch('pages/loadPages')
store.dispatch('reports/loadReports')
store.dispatch('tracers/loadTracers')

export default store
