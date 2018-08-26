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
      <router-link to="/" class="navbar-item">Home</router-link>
      <router-link to="/tracers" class="navbar-item">Tracers</router-link>
      <router-link to="/leaderboard" class="navbar-item">Leaderboard</router-link>

        <div class="navbar-item has-dropdown is-hoverable"
        v-for="(pageByCategory, index) in this.getAllPagesByCategory"
        v-bind:key="index">
          <p class="navbar-link">
            {{ pageByCategory.category | capitalize}}
          </p>
          <div class="navbar-dropdown">
            <router-link class="navbar-item" :to="{name: 'pages', params: {category: pageByCategory.category, page: pageName}}"
            v-for="(pageName, index) in pageByCategory.pagesName"
            v-bind:key="index">{{ pageName }}</router-link>
          </div>
        </div>
    </div>
  </nav>
</template>

<script>
import { createNamespacedHelpers } from 'vuex'
const { mapState, mapActions, mapGetters } = createNamespacedHelpers('pages')

document.addEventListener('DOMContentLoaded', function() {
  // Get all "navbar-burger" elements
  var $navbarBurgers = Array.prototype.slice.call(
    document.querySelectorAll('.navbar-burger'),
    0
  )

  // Check if there are any navbar burgers
  if ($navbarBurgers.length > 0) {
    // Add a click event on each of them
    $navbarBurgers.forEach(function($el) {
      $el.addEventListener('click', function() {
        // Get the target from the "data-target" attribute
        var target = $el.dataset.target
        var $target = document.getElementById(target)

        // Toggle the class on both the "navbar-burger" and the "navbar-menu"
        $el.classList.toggle('is-active')
        $target.classList.toggle('is-active')
      })
    })
  }
})

export default {
  name: 'MenuNav',
  async created() {},
  data() {
    return {
      apiUrl: this.$apiUrl,
      appName: this.$appName
    }
  },
  computed: {
    ...mapState({
      pages: state => state.data,
      loading: state => state.loading,
      myerrors: state => state.errors,
      success: state => state.success
    }),
    ...mapGetters(['getAllPagesByCategory'])
  },
  methods: {
    ...mapActions(['loadPages'])
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