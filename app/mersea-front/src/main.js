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
import { library } from '@fortawesome/fontawesome-svg-core'
import { faSearch, faThLarge, faThList } from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import moment from 'moment'

import 'buefy/lib/buefy.css'

Vue.config.productionTip = false

Vue.prototype.$http = axios
Vue.prototype.$appName = 'Ocean Plastic Tracker'
Vue.prototype.$apiUrl = process.env.API_URL

Vue.use(Vuex)
Vue.use(Buefy)

library.add(faSearch, faThList, faThLarge)
Vue.component('font-awesome-icon', FontAwesomeIcon)

Vue.filter('formatDate', function (value) {
  return moment(String(value)).format('MM/DD/YYYY hh:mm')
})

new Vue({
  el: '#app',
  router,
  template: '<App/>',
  components: { App }
})
