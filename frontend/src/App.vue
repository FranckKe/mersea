<template>
  <div id="app" class="app">
    <MenuNav></MenuNav>
    <transition name="fade" mode="out-in">
      <router-view></router-view>
    </transition>
  </div>
</template>

<script>
import MenuNav from '@/components/MenuNav'

export default {
  name: 'app',
  components: {
    MenuNav
  },
  created() {
    this.$auth.ready()
  },
  data() {
    return {
      appName: this.$appName
    }
  },
  methods: {}
}
</script>

<style lang="scss">
// Import Bulma's core
@import '~bulma/sass/utilities/_all';

// Bulma color customization
$primary: #4099ff;
$primary-invert: findColorInvert($primary);

$colors: (
  'white': (
    $white,
    $black
  ),
  'black': (
    $black,
    $white
  ),
  'light': (
    $light,
    $light-invert
  ),
  'dark': (
    $dark,
    $dark-invert
  ),
  'primary': (
    $primary,
    $primary-invert
  ),
  'info': (
    $info,
    $info-invert
  ),
  'success': (
    $success,
    $success-invert
  ),
  'warning': (
    $warning,
    $warning-invert
  ),
  'danger': (
    $danger,
    $danger-invert
  )
);

$link: $primary;
$link-invert: $primary-invert;
$link-focus-border: $primary;
$navbar-breakpoint: 1024px;

.app .button.is-primary:active,
.app .button.is-primary.is-active {
  background-color: darken($primary, 25%);
}

.app .button.is-info:active,
.app .button.is-info.is-active {
  background-color: darken($info, 25%);
}

.app .button.is-success:active,
.app .button.is-success.is-active {
  background-color: darken($success, 25%);
}

.app .button.is-warning:active,
.app .button.is-warning.is-active {
  background-color: darken($warning, 25%);
}

.app .button.is-danger:active,
.app .button.is-danger.is-active {
  background-color: darken($danger, 25%);
}

// Import Bulma and Buefy styles
@import '~bulma';
@import '~buefy/src/scss/buefy';

:root {
  --header-height: 52px;
  --primary: #{$primary};
  @custom-media --only-small (width < 500px);
  @custom-media --only-medium (width >= 500px) and (width <= 839px);
  @custom-media --below-medium (width < 839px);
  @custom-media --only-large (width >= 839px) and (width <= 1024px);
  @custom-media --below-large (width <= 1024px);
}

html {
  overflow-y: auto;
}

body {
  margin: 0;
}

.app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  padding-top: var(--header-height);
  & > .section {
    padding-top: var(--header-height);
  }
}

/* Bulma toast opacity override */
body .notices.toast {
  opacity: 1;
}

.loading-overlay.is-active {
  z-index: 999;
}

/* Fix margin for input type file error message */
.file .is-danger {
  padding-top: 5px;
  margin-left: 10px;
}

/* Bulma-step override */

.app .steps .step-item.is-active .step-marker,
.app .steps .step-item.is-success.is-active .step-marker {
  color: $primary;
}

.app .steps .step-item.is-success.is-active .step-marker,
.app .steps .step-item.is-active .step-marker {
  border-color: $primary;
}

.app .steps .step-item.is-success.is-completed .step-marker,
.app .steps .step-item.is-completed .step-marker {
  background-color: $primary;
}

.app .steps .step-item::before {
  background: linear-gradient(to left, #dbdbdb 50%, $primary 50%);
  background-size: 200% 100%;
  background-position: right bottom;
}

@media only screen and (max-device-width: 1024px) {
  .app {
    padding-top: 0; /* Overlap nav bar with tool bar */
  }
}
</style>
