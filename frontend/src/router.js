import Vue from 'vue'
import Router from 'vue-router'
import Home from './views/Home'
import Register from './views/Register'
import Me from './views/Me'
import MyReports from './views/MyReports'
import Login from './views/Login'
import Leaderboard from './views/Leaderboard'
import Tracers from './views/Tracers'
import Page from './views/Page'

Vue.use(Router)

let routes = [
  {
    path: '/',
    name: 'home',
    component: Home
  },
  {
    path: '/register',
    name: 'register',
    component: Register
  },
  {
    path: '/login',
    name: 'login',
    component: Login
  },
  {
    path: '/me',
    name: 'me',
    meta: {
      auth: true
    },
    component: Me
  },
  {
    path: '/me/reports',
    name: 'myReports',
    meta: {
      auth: true
    },
    component: MyReports
  },
  {
    path: '/pages/:category/:page',
    name: 'pages',
    component: Page,
    props: true
  },
  {
    path: `/contributions`,
    component: Leaderboard,
    alias: '/contribuciones'
  },
  {
    path: '/tracers',
    component: Tracers,
    alias: '/trazadores'
  }
]
export default new Router({
  routes: routes
})
