import Vue from 'vue'
import Router from 'vue-router'
import Home from './views/Home'
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

// Attempt to dynamic routing naming
// const languages = ['en', 'es', 'fr'] // i18n.locales() doesn't work here
// languages.forEach(lang => {
//   defaultRoutes.forEach(route => {
//     routes.push({
//       // Translation always endup in 'en' even if locale variable is another value
//       path: `/${i18n.t(route.name, { locale: lang }).toLowerCase()}`,
//       component: route.component
//     })
//   })
// })

export default new Router({ routes: routes })
