import axios from 'axios'

const api = axios.create({
  baseURL: process.env.VUE_APP_API_URL,
  headers: { Accept: 'application/json', 'Content-Type': 'application/json' }
})

const state = {
  data: [],
  loading: true,
  success: false,
  errors: [],
  displayFormat: 'grid',
  perPage: '10'
}

const getters = {
  getLoading: state => {
    return state.loading
  },
  getError: state => {
    return state.errors
  },
  getSuccess: state => {
    return state.success
  },
  getData: state => {
    return state.data
  },
  getPerPage: state => {
    return state.perPage
  },
  getTracerById: state => tracerId =>
    state.data.filter(tracer => tracerId === tracer.id)[0]
}

const mutations = {
  setData: (state, { data }) => {
    state.data = data
  },
  setSuccess: state => {
    state.success = true
    state.loading = false
    state.errors = []
  },
  setError: (state, { errors }) => {
    state.errors = errors
    state.loading = false
  },
  setDisplayFormat: (state, format) => {
    state.displayFormat = format
  },
  setPerPage: (state, perPage) => {
    state.perPage = perPage
  }
}

const actions = {
  async loadTracers({ commit }) {
    try {
      const tracers = await api.get(`/tracers`)
      const data = tracers.data
      commit('setData', { data })
      commit('setSuccess')
    } catch (error) {
      let errors = [error.message]
      commit('setError', { errors })
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
