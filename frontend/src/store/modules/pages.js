import axios from 'axios'
import i18n from '../../i18n'
import slugify from 'slugify'

const api = axios.create({
  baseURL: process.env.VUE_APP_API_URL,
  headers: { Accept: 'application/json', 'Content-Type': 'application/json' },
  timeout: 15000
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
          .filter(
            pageCategory =>
              pageCategory !== 'other' && pageCategory !== 'welcome'
          )
      )
    ]
  },
  getAllPagesByCategory: state => {
    let categories = [
      ...new Set(
        state.pages
          .map(page => page.category)
          .filter(
            pageCategory =>
              pageCategory !== 'other' && pageCategory !== 'welcome'
          )
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
  setPages: (state, { pages }) => {
    state.pages = pages
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
  }
}
const actions = {
  loadPages({ commit }) {
    commit('setLoading', true)
    return api
      .get(`/pages`)
      .then(pagesData => {
        const pages = pagesData.data
        commit('setPages', { pages })
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
