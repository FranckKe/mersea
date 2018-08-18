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
import moment from 'moment'
import slugify from 'slugify'

import { library } from '@fortawesome/fontawesome-svg-core'
import {
  faSearch,
  faThLarge,
  faThList
} from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import '@fortawesome/fontawesome-free/css/solid.css'
import '@fortawesome/fontawesome-free/css/fontawesome.css'

import 'buefy/lib/buefy.css'

Vue.config.productionTip = false

const api = axios.create({
  baseURL: process.env.VUE_APP_API_URL,
  timeout: 1000,
  headers: { Accept: 'application/json', 'Content-Type': 'application/json' }
})

Vue.prototype.$http = api
Vue.prototype.$appName = 'Ocean Plastic Tracker'
Vue.prototype.$apiUrl = process.env.VUE_APP_API_URL

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

if (process.env.NODE_ENV !== 'production') {
  setTimeout(() => {
    app.$mount('#app')
  }, 500)
} else {
  app.$mount('#app')
}
