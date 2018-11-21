// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
/* eslint-disable no-unused-vars */
/* eslint-disable no-new */
import Vue from 'vue'
import App from './App.vue'
import i18n from './i18n'
import router from './router'
import store from './store'
import './registerServiceWorker'

import Buefy from 'buefy'
import axios from 'axios'
import VueAxios from 'vue-axios'
import VueAuth from '@websanova/vue-auth'
import moment from 'moment'
import slugify from 'slugify'
import en from 'vee-validate/dist/locale/en'
import es from 'vee-validate/dist/locale/es'
import fr from 'vee-validate/dist/locale/fr'
import VeeValidate, { Validator } from 'vee-validate'

import { library } from '@fortawesome/fontawesome-svg-core'
import {
  faSearch,
  faThLarge,
  faThList
} from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import '@fortawesome/fontawesome-free/css/solid.css'
import '@fortawesome/fontawesome-free/css/fontawesome.css'

import 'buefy/dist/buefy.css'
import 'bulma-steps/dist/css/bulma-steps.min.css'

Vue.config.productionTip = false

const api = axios.create({
  baseURL: process.env.VUE_APP_API_URL,
  timeout: 1000,
  headers: {
    Accept: 'application/json',
    'Content-Type': 'application/json'
  }
})

Vue.prototype.$http = api
Vue.prototype.$appName = 'Ocean Plastic Tracker'
Vue.prototype.$apiUrl = process.env.VUE_APP_API_URL || ''

Vue.router = router
router.afterEach(() => {
  Vue.nextTick(() => {
    const navbarBurger = document.querySelector('.navbar-burger')
    if (navbarBurger) {
      navbarBurger.classList.remove('is-active')
      document
        .querySelector(`#${navbarBurger.dataset.target}`)
        .classList.remove('is-active')
    }
  })
})

Vue.use(VueAxios, api)
Vue.use(VueAuth, {
  auth: require('@websanova/vue-auth/drivers/auth/bearer.js'),
  http: require('@websanova/vue-auth/drivers/http/axios.1.x.js'),
  router: require('@websanova/vue-auth/drivers/router/vue-router.2.x.js'),
  authRedirect: { name: 'login' },
  tokenDefaultName: 'mersea_auth_token',
  registerData: {
    url: 'users',
    method: 'POST',
    redirect: '/'
  },
  loginData: {
    url: 'users/sign_in',
    method: 'POST',
    redirect: '/'
  },
  logoutData: {
    url: 'users/sign_out',
    method: 'DELETE',
    redirect: '/',
    makeRequest: true
  },
  fetchData: {
    url: 'users/me',
    method: 'GET',
    enabled: true
  },
  refreshData: {
    url: 'users/me',
    method: 'GET',
    enabled: false,
    interval: 30
  },
  parseUserData: data => data
})

api.interceptors.response.use(
  response => {
    return response
  },
  error => {
    if (
      error.response.status === 401 &&
      ['UnauthorizedAccess', 'InvalidToken'].indexOf(error.response.data.code) >
        -1
    ) {
      Vue.auth.logout({
        redirect: '/'
      })
    } else if (error.response.status === 500) {
      this.$toast.open({
        message: error.response,
        duration: 5000,
        type: 'is-danger'
      })
    }
    return Promise.reject(error)
  }
)

Vue.use(Buefy, {
  defaultIconPack: 'fas'
})

library.add(faSearch, faThList, faThLarge)
Vue.component('font-awesome-icon', FontAwesomeIcon)

Vue.prototype.$filters = Vue.options.filters

Vue.filter('formatDate', value => moment(String(value)).format('MM/DD/YYYY'))

Vue.filter('capitalize', function(value) {
  if (!value) return ''
  value = value.toString()
  return value.charAt(0).toUpperCase() + value.slice(1)
})

Vue.filter('slugify', function(value) {
  return slugify(value)
})

let app = new Vue({
  render: h => h(App),
  router,
  i18n,
  store
})

// Initialize lang if present in state
// It is only present in state if user previously visited the app
if (store.state.lang !== '') {
  i18n.locale = store.state.lang
} else {
  store.state.lang = i18n.locale
}

Validator.localize(i18n.locale)

Vue.use(VeeValidate, {
  locale: i18n.locale,
  i18n: i18n,
  i18nRootKey: 'validations',
  dictionary: {
    en: en,
    fr: fr,
    es: es
  }
})

if (process.env.NODE_ENV !== 'production') {
  setTimeout(() => {
    app.$mount('#app')
  }, 500)
} else {
  app.$mount('#app')
}
