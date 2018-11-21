import axios from 'axios'
// import i18n from '../../i18n'
// import slugify from 'slugify'

const api = axios.create({
  baseURL: process.env.VUE_APP_API_URL,
  timeout: 1000,
  headers: { Accept: 'application/json', 'Content-Type': 'application/json' }
})

const state = {
  data: {},
  loading: true,
  success: false,
  errors: []
}

const getters = {
  getLoading: state => state.loading,
  getErrors: state => state.errors,
  getSuccess: state => state.success,
  getData: state => state.data,
  getEmail: state => state.data.email
}
const mutations = {
  updateUserData: (state, { userData }) => {
    state.data = userData
  },
  updateErrors: (state, { errors }) => {
    state.errors = errors
  },
  updateSuccess: (state, { success }) => {
    state.success = success
    state.loading = false
    state.errors = []
  }
}
const actions = {
  async loadUserData({ commit }, { vm }) {
    commit('updateUserData', { userData: vm.$auth.user() })
  }
}

export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations
}
