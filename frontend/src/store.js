import Vue from 'vue'
import Vuex from 'vuex'
import axios from 'axios'
import createPersistedState from 'vuex-persistedstate'

const api = axios.create({
  baseURL: process.env.VUE_APP_API_URL,
  timeout: 1000,
  headers: { Accept: 'application/json', 'Content-Type': 'application/json' }
})

Vue.prototype.$http = api

Vue.use(Vuex)

const pages = {
  namespaced: true,
  state: {
    payload: [],
    loading: true,
    success: false,
    error: {}
  },
  mutations: {
    updatePayload: (state, { payload }) => {
      state.payload = payload
    },
    updateSuccess: (state, { success }) => {
      state.success = success
      state.loading = false
    },
    updateError: (state, { error }) => {
      state.error = error
      state.loading = false
    }
  },
  actions: {
    loadPages: async ({ commit }) => {
      try {
        const pages = await api.get(`/pages`)
        const payload = pages.data

        commit('updatePayload', { payload })
      } catch (e) {
        commit('updateError', { e })
      }
    }
  }
}

export default new Vuex.Store({
  plugins: [createPersistedState()],
  modules: {
    pages: pages
  },
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
