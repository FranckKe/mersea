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
  updateData: (state, payload) => {
    state.reports = payload.reports
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
      let reportsData = reports.data
      commit('updateData', { reports: reportsData })
      commit('updateSuccess')
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
