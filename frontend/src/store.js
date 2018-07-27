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
    data: [],
    loading: true,
    success: false,
    errors: []
  },
  getters: {
    getLoading: state => {
      return state.loading
    },
    geterror: state => {
      return state.errors
    },
    getSuccess: state => {
      return state.success
    },
    getAllPagesByCategory: state => {
      let categories = [
        ...new Set(
          state.data
            .map(page => page.category)
            .filter(page => page.category !== 'other')
        )
      ]
      return categories.map(function(category) {
        return {
          category: category,
          pagesName: state.data
            .filter(page => page.category === category)
            .map(page => page.name)
        }
      })
    },
    getPagesByCategory(state) {
      return category => {
        return {
          category: category,
          pagesName: state.data
            .filter(page => page.category === category)
            .map(page => page.name)
        }
      }
    }
  },
  mutations: {
    updateData: (state, { data }) => {
      state.data = data
    },
    updateSuccess: state => {
      state.success = true
      state.loading = false
      state.errors = []
    },
    updateError: (state, { errors }) => {
      state.errors = errors
      state.loading = false
    }
  },
  actions: {
    loadPages: ({ commit }) => {
      return new Promise(async (resolve, reject) => {
        try {
          const pages = await api.get(`/pages`)
          const data = pages.data

          commit('updateData', { data })
          commit('updateSuccess', { data })
          resolve()
        } catch (error) {
          let errors = [error.message]
          commit('updateError', { errors })
          reject(error.message)
        }
      })
    }
  }
}

export default new Vuex.Store({
  // plugins: [createPersistedState()],
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
