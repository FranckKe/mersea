import axios from 'axios'

const api = axios.create({
  baseURL: process.env.VUE_APP_API_URL,
  timeout: 1000,
  headers: { Accept: 'application/json', 'Content-Type': 'application/json' }
})

const state = {
  data: [],
  loading: true,
  success: false,
  errors: []
}
const getters = {
  getLoading: state => {
    return state.loading
  },
  geterror: state => {
    return state.errors
  },
  getSuccess: state => {
    return state.success
  }
}
const mutations = {
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
}
const actions = {
  async loadReports({ commit }) {
    try {
      const reports = await api.get(`/reports`, {
        headers: {
          Accept: 'application/geo+json',
          'Content-Type': 'application/geo+json'
        }
      })
      const data = reports.data
      commit('updateData', { data })
      commit('updateSuccess', { data })
    } catch (error) {
      let errors = [error.message]
      commit('updateError', { errors })
    }
  }
}

export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations
}
