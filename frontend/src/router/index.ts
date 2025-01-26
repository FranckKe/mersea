import { createRouter, createWebHistory } from "vue-router"
import HomeView from "../views/HomeView.vue"

// function for component value is route level code-splitting
// this generates a separate chunk ([viewname].[hash].js) for this route
// which is lazy-loaded when the route is visited.

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: "/",
      name: "home",
      component: HomeView
    },
    // --- PUBLIC --- //
    {
      path: "/tracers",
      alias: ["/traceurs", "/trazadores"],
      name: "tracers",
      component: () => import("../views/TracersView.vue")
    },
    {
      path: "/contributions",
      alias: ["/contributions", "/contributiones"],
      name: "contributions",
      component: () => import("../views/LeaderboardView.vue")
    },
    {
      // TODO remove this entry?
      path: "/pages",
      alias: ["/pages", "/páginas"],
      name: "pages",
      component: () => import("../views/PageView.vue")
    },
    {
      path: "/pages/:id",
      alias: ["/pages/:id", "/páginas/:id"],
      name: "page",
      component: () => import("../views/PageView.vue")
    },
    // --- AUTH --- //
    {
      path: "/login", // TODO localize
      name: "login",
      alias: ["/connexion", "/todo"],
      meta: {
        auth: false,
        redirect: "/"
      },
      component: () => import("../views/LoginView.vue")
    },
    {
      path: "/register", // TODO localize
      name: "register",
      alias: ["/inscription", "/todo"],
      meta: {
        auth: false,
        redirect: "/"
      },
      component: () => import("../views/RegisterView.vue")
    },
    {
      path: "/forgotten-password", // TODO localize
      name: "forgotten-password",
      alias: ["/mot-de-pass-oublie", "/todo"],
      meta: {
        auth: false,
        redirect: "/"
      },
      component: () => import("../views/ForgottenPasswordView.vue")
    },
    {
      path: "/reset-password", // TODO localize
      name: "reset-password",
      alias: ["/mot-de-pass-oublie", "/todo"],
      meta: {
        auth: false,
        redirect: "/"
      },
      component: () => import("../views/ResetPasswordView.vue")
    },
    // --- ACCOUNT --- //
    {
      path: "/account",
      name: "account",
      meta: {
        auth: true,
        redirect: "/login"
      },
      component: () => import("../views/AccountView.vue")
    }
    // {
    //   path: '/account/reports',
    //   name: 'accountReports',
    //   meta: {
    //     auth: true
    //   },
    //   component: MyReports // TODO have a child view for that
    // },
  ]
})

export default router
