import Vue from 'vue'
import Router from 'vue-router'
import Home from './views/Home'
import Leaderboard from './views/Leaderboard'
import Tracers from './views/Tracers'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'Home',
      component: Home
    },
    {
      path: '/leaderboard',
      name: 'Leaderboard',
      component: Leaderboard
    },
    {
      path: '/tracers',
      name: 'Tracers',
      component: Tracers
    }
  ]
})
