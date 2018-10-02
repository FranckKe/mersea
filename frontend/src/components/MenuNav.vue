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
      <router-link to="/" class="navbar-item">{{ $t('home') }}</router-link>
      <router-link :to="`/${$t('tracers').toLowerCase()}`" class="navbar-item">{{ $t('tracers') }}</router-link>
      <router-link :to="`/${$t('leaderboard').toLowerCase()}`" class="navbar-item">{{ $t('leaderboard') }}</router-link>

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
    </div>
  </nav>
</template>

<script>
import slugify from 'slugify'
import { createNamespacedHelpers } from 'vuex'
const { mapState, mapActions, mapGetters } = createNamespacedHelpers('pages')
import LangSwitcher from '@/components/LangSwitcher'

const initResponsiveMenu = () => {
  // Get all "navbar-burger" elements
  const $navbarBurgers = Array.prototype.slice.call(
    document.querySelectorAll('.navbar-burger'),
    0
  )

  // Check if there are any navbar burgers
  if ($navbarBurgers.length > 0) {
    // Add a click event on each of them
    $navbarBurgers.forEach(function($el) {
      $el.addEventListener('click', function() {
        // Get the target from the "data-target" attribute
        const target = $el.dataset.target
        const $target = document.getElementById(target)

        // Toggle the class on both the "navbar-burger" and the "navbar-menu"
        $el.classList.toggle('is-active')
        $target.classList.toggle('is-active')
      })
    })
  }
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
    slugify: slugify
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

@media (--below-large) {
  .navbar-menu.is-active {
    height: 100vh;
  }
}
</style>

<i18n>
{
  "en": {
    "home": "Home",
    "tracers": "Tracers",
    "leaderboard": "Contributions",
    "about": "About",
    "information": "Information",
    "other": "Other"
  },
  "fr": {
    "home": "Accueil",
    "tracers": "Tracers",
    "leaderboard": "Contributions",
    "about": "À propos",
    "information": "Information",
    "other": "Autre"
  },
  "es": {
    "home": "Inicio",
    "tracers": "Trazadores",
    "leaderboard": "Contribuciones",
    "about": "Acerca de",
    "information": "información",
    "other": "Otro"
  }
}
</i18n>
