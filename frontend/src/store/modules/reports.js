import axios from 'axios'

const api = axios.create({
  baseURL: process.env.VUE_APP_API_URL,
  headers: { Accept: 'application/json', 'Content-Type': 'application/json' }
})

const state = {
  reports: [],
  loading: true,
  success: false,
  errors: []
}
const getters = {
  getLoading: state => {
    return state.loading
  },
  getErrors: state => {
    return state.errors
  },
  getSuccess: state => {
    return state.success
  },
  getReports: state => {
    return state.reports
  },
  getFilteredReports: state => tracerIds => {
    return {
      features: state.reports.features.filter(report =>
        tracerIds.includes(report.properties.tracer_id)
      ),
      type: 'FeatureCollection'
    }
  },
  getReportCount: state => tracerId =>
    state.reports.features.filter(
      report => tracerId === report.properties.tracer_id
    ).length
}
const mutations = {
  setLoading: (state, loading) => {
    state.loading = loading
  },
  setData: (state, payload) => {
    state.reports = payload.reports
  },
  setSuccess: state => {
    state.success = true
    state.loading = false
    state.errors = []
  },
  setError: (state, { errors }) => {
    state.errors = errors
    state.loading = false
  }
}
const actions = {
  async loadReports({ commit }, { reported_at_min, reported_at_max }) {
    try {
      commit('setLoading', true)
      const reports = await api.get(
        `/reports?r_min_reported_at=${reported_at_min}&r_max_reported_at=${reported_at_max}`,
        {
          headers: {
            Accept: 'application/geo+json',
            'Content-Type': 'application/geo+json'
          }
        }
      )
      let reportsData = reports.data
      commit('setData', { reports: reportsData })
      commit('setSuccess')
    } catch (e) {
      let errors = [e.message]
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
