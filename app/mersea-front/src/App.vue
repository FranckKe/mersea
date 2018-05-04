<template>
  <div class="app">
    <header>
      <h1>{{ appName }}</h1>
    </header>
    <main>
      <router-view></router-view>
    </main>
  </div>
</template>

<script>
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
:root {
  --header-height: 40px;

  --color-primary: #0093b7;
  --color-primary-dark: #005f89;
  --color-primary-ligth: #a0c5cf;
  --color-light: #e6eceb;
  --color-secondary: #63cdd7;
  --color-primary-t1: #ffb100;
  --color-primary-t2: #ff1e00;
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

header {
  margin: 0;
  height: var(--header-height);
  padding: 0 16px 0 24px;
  background-color: var(--color-primary);
  color: var(--color-light);
  display: flex;
  justify-content: center;
  align-items: center;
}

header span {
  display: block;
  position: relative;
  font-size: 20px;
  line-height: 1;
  letter-spacing: 0.02em;
  font-weight: 400;
  box-sizing: border-box;
  padding-top: 16px;
}
</style>
