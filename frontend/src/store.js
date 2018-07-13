import Vue from 'vue'
import Vuex from 'vuex'
import createPersistedState from 'vuex-persistedstate'

Vue.config.devtools

Vue.use(Vuex)

export default new Vuex.Store({
  plugins: [createPersistedState()],
  state: {
    tracersDisplayFormat: 'grid',
    tracersListPerPage: '10'
  },
  mutations: {
    updateTracersDisplayFormat: (state, { format }) => {
      state.tracersDisplayFormat = format
    },
    updateTracersListPerPage: (state, { perPage }) => {
      state.tracersListPerPage = perPage
    }
  },
  actions: {}
})
