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
  },
  getPageContent: state => {
    return pageInfo => {
      return (
        state.data.filter(
          page =>
            page.category === pageInfo.category &&
            page.name === pageInfo.pageName
        )[0] || {}
      ).content
    }
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
  async loadPages({ commit }) {
    try {
      const pages = await api.get(`/pages`)
      const data = pages.data
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
