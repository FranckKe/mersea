<template>
  <div id="app">
    <nav class="navbar is-fixed-top" role="navigation" aria-label="main navigation">
      <div class="navbar-brand">
        <div class="navbar-start">
          <a role="button" class="navbar-burger" aria-label="menu" data-target="flexible-menu" aria-expanded="false">
            <span aria-hidden="true"></span>
            <span aria-hidden="true"></span>
            <span aria-hidden="true"></span>
          </a>
        </div>

        <a class="navbar-item" href="https://bulma.io">
          <img src="https://bulma.io/images/bulma-logo.png" alt="Bulma: a modern CSS framework based on Flexbox" width="112" height="28">
        </a>
      </div>
      <div id="flexible-menu" class="navbar-menu">
        <router-link to="/" class="navbar-item">Home</router-link>
        <div class="navbar-item has-dropdown is-hoverable">
          <p class="navbar-link">
            About us
          </p>

          <div class="navbar-dropdown">
            <router-link to="/project" class="navbar-item">Project</router-link>
            <router-link to="/ansel" class="navbar-item">ANSEL</router-link>
          </div>
        </div>
        <div class="navbar-item has-dropdown is-hoverable">
          <p class="navbar-link">
            More
          </p>
          <div class="navbar-dropdown">
            <router-link to="/links" class="navbar-item">Links</router-link>
            <router-link to="/security" class="navbar-item">Security</router-link>
            <router-link to="/legal-mentions" class="navbar-item">Legal mentions</router-link>
          </div>
        </div>
      </div>
    </nav>
    <router-view>
    </router-view>
  </div>
</template>

<script>
document.addEventListener('DOMContentLoaded', function () {

  // Get all "navbar-burger" elements
  var $navbarBurgers = Array.prototype.slice.call(document.querySelectorAll('.navbar-burger'), 0);

  // Check if there are any navbar burgers
  if ($navbarBurgers.length > 0) {

    // Add a click event on each of them
    $navbarBurgers.forEach(function ($el) {
      $el.addEventListener('click', function () {

        // Get the target from the "data-target" attribute
        var target = $el.dataset.target;
        var $target = document.getElementById(target);

        // Toggle the class on both the "navbar-burger" and the "navbar-menu"
        $el.classList.toggle('is-active');
        $target.classList.toggle('is-active');

      });
    });
  }
});

export default {
  name: 'app',
  data() {
    return {
      appName: this.$appName
    }
  }
}
</script>

<style>
html {
  overflow-y: auto;
}

.navbar {
  background-color: #DDD;
}

p.navbar-link {
  cursor: default;
}

@media screen and (max-width: 1023px) {
  .navbar-menu.is-active {
    height: 100vh;
  }
}
</style>
