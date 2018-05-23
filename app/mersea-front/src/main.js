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

import 'buefy/lib/buefy.css'

Vue.config.productionTip = false

Vue.prototype.$http = axios
Vue.prototype.$appName = 'Ocean Plastic Tracker'
Vue.prototype.$apiUrl = process.env.API_URL

new Vue({
  el: '#app',
  router,
  template: '<App/>',
  components: { App }
})

Vue.use(Vuex)
Vue.use(Buefy)
