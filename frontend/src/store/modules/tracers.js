import axios from 'axios'

const api = axios.create({
  baseURL: process.env.VUE_APP_API_URL,
  headers: { Accept: 'application/json', 'Content-Type': 'application/json' },
  timeout: 15000
})

const state = {
  tracers: [],
  filteredTracers: [],
  loading: true,
  success: false,
  errors: [],
  displayFormat: 'grid',
  perPage: '10'
}

const getters = {
  getFilteredTracers: state => {
    return state.filteredTracers
  },
  getLoading: state => {
    return state.loading
  },
  getError: state => {
    return state.errors
  },
  getSuccess: state => {
    return state.success
  },
  getTracers: state => {
    return state.tracers
  },
  getPerPage: state => {
    return state.perPage
  },
  getCategories: state => {
    let categories = [
      ...new Set(
        JSON.parse(JSON.stringify(state.tracers)).map(tracer => tracer.category)
      )
    ].sort()

    if (categories[0] === 'archive') categories.shift()
    categories.push('archive')

    return categories
  },
  getTracerById: state => tracerId =>
    state.tracers.filter(tracer => tracerId === tracer.id)[0]
}

const mutations = {
  setTracers: (state, { tracers }) => {
    state.tracers = tracers
  },
  setLoading: (state, loading) => {
    state.loading = loading
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
  },
  setFilteredTracers: (state, filteredTracers) => {
    state.filteredTracers = filteredTracers
  }
}

const actions = {
  loadTracers({ commit }) {
    commit('setLoading', true)
    return api
      .get(`/tracers`)
      .then(tracersRes => {
        const tracers = tracersRes.data
        commit('setTracers', { tracers })
        commit(
          'setFilteredTracers',
          tracers.map(t => t.id)
        )
        commit('setSuccess')
      })
      .catch(e => {
        console.error(e)
        let errors = [e.message]
        commit('setError', { errors })
      })
  }
}

export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations
}
