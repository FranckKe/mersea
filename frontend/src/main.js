// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
/* eslint-disable no-unused-vars */
/* eslint-disable no-new */
import Vue from 'vue'
import App from './App'
import router from './router'
import Vuex from 'vuex'
import Buefy from 'buefy'
import axios from 'axios'
import moment from 'moment'
import { library } from '@fortawesome/fontawesome-svg-core'
import {
  faSearch,
  faThLarge,
  faThList
} from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import '@fortawesome/fontawesome-free-webfonts/css/fa-solid.css'
import '@fortawesome/fontawesome-free-webfonts/css/fontawesome.css'
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

Vue.use(Vuex)
Vue.use(Buefy, {
  defaultIconPack: 'fas'
})

library.add(faSearch, faThList, faThLarge)
Vue.component('font-awesome-icon', FontAwesomeIcon)

Vue.filter('formatDate', function(value) {
  return moment(String(value)).format('MM/DD/YYYY')
})

new Vue({
  render: h => h(App),
  router
}).$mount('#app')
