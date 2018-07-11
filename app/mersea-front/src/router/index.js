import Vue from 'vue'
import Router from 'vue-router'
import Home from '@/components/Home'
import Leaderboard from '@/components/Leaderboard'
import Tracers from '@/components/Tracers'

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
