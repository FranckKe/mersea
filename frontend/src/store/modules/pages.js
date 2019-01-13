import axios from 'axios'
import i18n from '../../i18n'
import slugify from 'slugify'

const api = axios.create({
  baseURL: process.env.VUE_APP_API_URL,
  headers: { Accept: 'application/json', 'Content-Type': 'application/json' }
})

const state = {
  pages: [],
  loading: true,
  success: false,
  errors: []
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
  getPageContent: state => {
    return pageInfo => {
      return (
        state.pages.filter(page => page.slug === pageInfo.pageName)[0] || {}
      ).content
    }
  },
  getCategories: state => {
    return [
      ...new Set(
        state.pages
          .map(page => page.category)
          .filter(page => page.category !== 'other')
      )
    ]
  },
  getAllPagesByCategory: state => {
    let categories = [
      ...new Set(
        state.pages
          .map(page => page.category)
          .filter(page => page.category !== 'other')
      )
    ]
    return categories.map(function(category) {
      return {
        category: slugify(category),
        pagesName: state.pages
          .filter(
            page => page.category === category && page.language === i18n.locale
          )
          .map(page => {
            return { raw: page.name, slug: page.slug }
          })
      }
    })
  },
  getPagesByCategory(state) {
    return category => {
      return state.pages
        .filter(
          page => page.category === category && page.language === i18n.locale
        )
        .map(page => {
          return { raw: page.name, slug: page.slug }
        })
    }
  }
}
const mutations = {
  updatePages: (state, { pages }) => {
    state.pages = pages
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
      const pagesData = await api.get(`/pages`)
      const pages = pagesData.data
      commit('updatePages', { pages })
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
