import axios from 'axios'

const api = axios.create({
  baseURL: process.env.VUE_APP_API_URL,
  headers: { Accept: 'application/json', 'Content-Type': 'application/json' },
  timeout: 15000
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
      features: (state.reports.features || []).filter(report =>
        tracerIds.includes(report.properties.tracer_id)
      ),
      type: 'FeatureCollection'
    }
  },
  getReportCount: state => tracerId =>
    (state.reports.features || []).reduce((sum, report) => {
      return tracerId === report.properties.tracer_id
        ? (sum += report.properties.quantity)
        : sum
    }, 0),
  getReportsEveryKilometers: state => tracerId => {
    let reportWithShoreLength = 0
    const sumDistanceBetweenReports = (state.reports.features || []).reduce((sum, report) => {
      if (tracerId === report.properties.tracer_id && report.properties.shore_length) {
        reportWithShoreLength++
        sum += (report.properties.shore_length / 1000) / report.properties.quantity
      }
      return sum
    }, 0)
    if (sumDistanceBetweenReports > 0 && reportWithShoreLength > 0){
      return sumDistanceBetweenReports / reportWithShoreLength
    } else {
      return Infinity
    }
 }
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
  loadReports({ commit }, { reported_at_min, reported_at_max }) {
    commit('setLoading', true)
    return api
      .get(
        `/reports?r_min_reported_at=${reported_at_min}&r_max_reported_at=${reported_at_max}`,
        {
          headers: {
            Accept: 'application/geo+json',
            'Content-Type': 'application/geo+json'
          }
        }
      )
      .then(reports => {
        let reportsData = reports.data
        commit('setData', { reports: reportsData })
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
