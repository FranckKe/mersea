<template>
  <nav class="navbar is-fixed-top" role="navigation" aria-label="main navigation">
    <b-loading :is-full-page="false" :active.sync="this.loading" :can-cancel="true"></b-loading>
    <div class="navbar-brand">
      <div class="navbar-start">
        <a role="button" class="navbar-burger" aria-label="menu" data-target="flexible-menu" aria-expanded="false">
          <span aria-hidden="true"></span>
          <span aria-hidden="true"></span>
          <span aria-hidden="true"></span>
        </a>
      </div>
    </div>
    <div id="flexible-menu" class="navbar-menu">
      <router-link to="/" class="navbar-item">
        {{ $t('home') }}
      </router-link>
      <router-link :to="`/${$t('tracers').toLowerCase()}`" class="navbar-item">
        {{ $t('tracers') }}
      </router-link>
      <router-link :to="`/${$t('leaderboard').toLowerCase()}`" class="navbar-item">
        {{ $t('leaderboard') }}
      </router-link>

      <div class="navbar-item has-dropdown is-hoverable"
        v-for="(category, index) in getCategories"
        v-bind:key="index">
        <p class="navbar-link">
          {{ $t(category) }}
        </p>
        <div class="navbar-dropdown">
          <router-link
            class="navbar-item"
            v-for="(pageName, index) in getPagesByCategory(category)"
            v-bind:key="index"
            :to="{
              name: 'pages',
              params: {
                category: slugify($t(category)).toLowerCase(),
                page: pageName.slug,
              }
            }">
              {{ pageName.raw }}
            </router-link>
        </div>
      </div>
      <lang-switcher></lang-switcher>
      <div class="navbar-end buttons">
        <button v-if="$auth.check()" v-on:click="logout()" class="button is-danger">{{ $t('logout') }}</button>
        <router-link v-if="$auth.check()" :to="'me'" class="button">{{ $t('my_account') }}</router-link>
        <router-link v-if="!$auth.check()" :to="'login'" class="button">{{ $t('login') }}</router-link>
        <router-link v-if="!$auth.check()" :to="'register'" class="button is-success">{{ $t('register') }}</router-link>
      </div>
    </div>
  </nav>
</template>

<script>
import slugify from 'slugify'
import { createNamespacedHelpers } from 'vuex'
const { mapState, mapActions, mapGetters } = createNamespacedHelpers('pages')
import LangSwitcher from '@/components/LangSwitcher'

const initResponsiveMenu = () => {
  const navbarBurger = document.querySelector('.navbar-burger')
  const $target = document.querySelector(`#${navbarBurger.dataset.target}`)

  navbarBurger.addEventListener('click', () => {
    navbarBurger.classList.toggle('is-active')
    $target.classList.toggle('is-active')
  })
}

export default {
  name: 'MenuNav',
  components: {
    LangSwitcher
  },
  data() {
    return {
      locale: 'en',
      apiUrl: this.$apiUrl,
      appName: this.$appName
    }
  },
  mounted() {
    initResponsiveMenu()
  },
  computed: {
    ...mapState({
      pages: state => state.pages,
      loading: state => state.loading,
      myerrors: state => state.errors,
      success: state => state.success
    }),
    ...mapGetters([
      'getAllPagesByCategory',
      'getPagesByCategory',
      'getCategories'
    ])
  },
  methods: {
    ...mapActions(['loadPages']),
    slugify: slugify,
    logout: function() {
      this.$auth.logout({
        makeRequest: true,
        params: {},
        success: () => {
          this.$toast.open({
            message: this.$t('logout_success'),
            duration: 5000,
            type: 'is-success'
          })
        },
        error: () => {
          this.$toast.open({
            message: this.$t('logout_failure'),
            duration: 5000,
            type: 'is-danger'
          })
        }
      })
    }
  }
}
</script>

<style>
h1.app-title {
  margin: 0;
  height: 100%;
  min-height: 3.25rem;
  padding: 0.5rem 1rem;
  display: flex;
  justify-content: center;
  align-items: center;
}

.navbar {
  background-color: var(--color-light);
}

p.navbar-link {
  cursor: default;
}

.navbar-end {
  padding: 0.5rem 0.75rem;
}

.navbar-end.buttons .button {
  margin-bottom: 0;
}

.navbar-end.buttons:last-child {
  margin-bottom: 0;
}

@media (--below-large) {
  .navbar-menu.is-active {
    height: 100vh;
  }
}
</style>

<i18n>
{
  "en": {
    "about": "About",
    "home": "Home",
    "information": "Information",
    "leaderboard": "Contributions",
    "login": "Login",
    "logout_failure": "Error during logout",
    "logout_success": "You are now logged out",
    "logout": "Logout",
    "my_account": "My account",
    "other": "Other",
    "register": "Register",
    "tracers": "Tracers"
  },
  "fr": {
    "about": "À propos",
    "home": "Accueil",
    "information": "Information",
    "leaderboard": "Contributions",
    "login": "Connexion",
    "logout_failure": "Erreur lors de la déconnexion",
    "logout_success": "Vous êtes maintenant déconnecté(e)",
    "logout": "Déconnexion",
    "my_account": "Mon compte",
    "other": "Autre",
    "register": "Inscription",
    "tracers": "Tracers"
  },
  "es": {
    "about": "Acerca de",
    "home": "Inicio",
    "information": "información",
    "leaderboard": "Contribuciones",
    "login": "Iniciar sesión",
    "logout_failure": "Error durante el sesión finalizada",
    "logout_success": "Sesión finalizada",
    "logout": "Sesión finalizada",
    "my_account": "Mi cuenta",
    "other": "Otro",
    "register": "Registrarse",
    "tracers": "Trazadores"
  }
}
</i18n>
