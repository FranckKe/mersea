<template>
  <nav
    class="navbar is-fixed-top"
    role="navigation"
    aria-label="main navigation"
  >
    <b-loading
      :is-full-page="false"
      :active.sync="this.loading"
      :can-cancel="false"
    ></b-loading>
    <div class="navbar-brand">
      <div class="navbar-start">
        <a
          role="button"
          class="navbar-burger"
          aria-label="menu"
          data-target="flexibleMenu"
          aria-expanded="false"
        >
          <span aria-hidden="true"></span>
          <span aria-hidden="true"></span>
          <span aria-hidden="true"></span>
        </a>
      </div>
    </div>
    <div id="flexibleMenu" class="navbar-menu">
      <router-link to="/" class="navbar-item">{{ $t('home') }}</router-link>
      <router-link
        :to="`/${$t('tracers').toLowerCase()}`"
        class="navbar-item"
        >{{ $t('tracers') }}</router-link
      >
      <router-link
        :to="`/${$t('leaderboard').toLowerCase()}`"
        class="navbar-item"
        >{{ $t('leaderboard') }}</router-link
      >

      <div
        class="navbar-item has-dropdown is-hoverable"
        v-for="(category, index) in getCategories"
        v-bind:key="index"
      >
        <p class="navbar-link">{{ $t(category) }}</p>
        <div class="navbar-dropdown">
          <router-link
            class="navbar-item"
            v-for="(pageName, index) in getPagesByCategory(category)"
            v-bind:key="index"
            :to="
              `/pages/${slugify($t(category)).toLowerCase()}/${pageName.slug}`
            "
            >{{ pageName.raw }}</router-link
          >
        </div>
      </div>
      <lang-switcher></lang-switcher>
      <div class="navbar-end buttons">
        <b-dropdown v-if="$auth.check()" position="is-bottom-left" paddingless>
          <button class="button is-primary" slot="trigger">
            <span>{{ $auth.user().email }}</span>
            <b-icon pack="fas" icon="caret-down"></b-icon>
          </button>

          <b-dropdown-item>
            <router-link
              :to="'/me'"
              class="has-text-dark is-size-6 nav-dropdown-link"
            >
              <font-awesome-icon icon="user" />
              <p>{{ $t('my_account') }}</p>
            </router-link>
          </b-dropdown-item>
          <b-dropdown-item class="has-text-dark is-size-6">
            <router-link
              :to="'/me/reports'"
              class="has-text-dark is-size-6 nav-dropdown-link"
            >
              <font-awesome-icon icon="map-marker-alt" />
              <p>{{ $t('my_reports') }}</p>
            </router-link>
          </b-dropdown-item>
          <hr class="dropdown-divider" />
          <b-dropdown-item class="has-text-danger is-size-6">
            <a
              href="#"
              class="has-text-danger is-size-6 nav-dropdown-link"
              v-on:click="logout()"
            >
              <font-awesome-icon icon="sign-out-alt" />
              <p>{{ $t('logout') }}</p>
            </a>
          </b-dropdown-item>
        </b-dropdown>
        <router-link v-if="!$auth.check()" :to="'/login'" class="button">
          <p>{{ $t('login') }}</p>
        </router-link>
        <router-link
          v-if="!$auth.check()"
          :to="'/register'"
          class="button is-success"
          ><p>{{ $t('register') }}</p></router-link
        >
      </div>
    </div>
  </nav>
</template>

<script>
import slugify from 'slugify'
import { createNamespacedHelpers } from 'vuex'
const pagesModule = createNamespacedHelpers('pages')
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
      apiUrl: this.$apiUrl,
      appName: this.$appName
    }
  },
  mounted() {
    initResponsiveMenu()
  },
  computed: {
    ...pagesModule.mapState({
      pages: state => state.pages,
      loading: state => state.loading,
      myerrors: state => state.errors,
      success: state => state.success
    }),
    ...pagesModule.mapGetters([
      'getAllPagesByCategory',
      'getPagesByCategory',
      'getCategories'
    ])
  },
  methods: {
    ...pagesModule.mapActions(['loadPages']),
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

<style lang="scss" scoped>
.navbar {
  width: 56px;
  height: 56px;
}

.navbar-menu {
  width: 100vw;
  background-color: white;
}

.navbar-menu.is-active {
  position: absolute;
}

.navbar-link {
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

.dropdown-item {
  display: flex;
  padding: 0;
  justify-content: flex-start;
  align-items: center;
}

.nav-dropdown-link {
  width: 100%;
  padding: 0.375rem 1rem;
  display: flex;
  justify-content: center;
  align-items: center;
}

.nav-dropdown-link p {
  text-align: center;
  flex: 1;
}

.navbar-burger {
  color: var(--primary);
  width: 56px;
  height: 56px;
  span {
    height: 2px;
  }
}

@media screen and (min-width: 1024px) {
  .navbar {
    width: 100%;
  }
  .navbar-menu {
    width: 100%;
  }
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
    "my_reports": "My reports",
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
    "my_reports": "Mes rapports",
    "other": "Autre",
    "register": "Inscription",
    "tracers": "Traceurs"
  },
  "es": {
    "about": "Acerca de",
    "home": "Inicio",
    "information": "Información",
    "leaderboard": "Contribuciones",
    "login": "Iniciar sesión",
    "logout_failure": "Error durante el sesión finalizada",
    "logout_success": "Sesión finalizada",
    "logout": "Sesión finalizada",
    "my_account": "Mi cuenta",
    "my_reports": "Mis informes",
    "other": "Otro",
    "register": "Registrarse",
    "tracers": "Trazadores"
  }
}
</i18n>
