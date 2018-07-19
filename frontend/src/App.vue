<template>
  <div id="app">
    <MenuNav></MenuNav>
    <transition name="fade" mode="out-in">
      <router-view>
      </router-view>
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
  data() {
    return {
      appName: this.$appName
    }
  }
}
</script>

<style>
:root {
  --header-height: 40px;

  --color-primary: #0093b7;
  --color-primary-dark: #005f89;
  --color-primary-ligth: #a0c5cf;
  --color-light: #e6eceb;
  --color-secondary: #63cdd7;
  --color-primary-t1: #ffb100;
  --color-primary-t2: #ff1e00;

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
  color: var(--color-primary);
}
</style>
