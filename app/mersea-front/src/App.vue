<template>
  <div id="app">
    <Slideout menu="#menu" panel="#panel" :toggleSelectors="['.toggle-button']" @on-open="open">
      <nav id="menu">
        <aside class="menu">
          <p class="menu-label">
            General
          </p>
          <ul class="menu-list">
            <li>
              <router-link to="/">Home</router-link>
            </li>
            <li>
              <router-link to="/">Tracers</router-link>
            </li>
            <li>
              <router-link to="/">Contributors</router-link>
            </li>
          </ul>
          <p class="menu-label">
            About us
          </p>
          <ul class="menu-list">
            <li>
              <router-link to="/">Project</router-link>
            </li>
            <li>
              <router-link to="/">ANSEL</router-link>
            </li>
          </ul>
          <p class="menu-label">
            Information
          </p>
          <ul class="menu-list">
            <li>
              <router-link to="/">Links</router-link>
            </li>
            <li>
              <router-link to="/">Security</router-link>
            </li>
            <li>
              <router-link to="/">Legal mentions</router-link>
            </li>
          </ul>
        </aside>
      </nav>
      <header>
        <button class="button toggle-button">☰</button>
        <h1 class="navbar-item app-title">
          {{ appName }}
        </h1>
      </header>

      <main id="panel">
      </main>
    </Slideout>
  </div>
</template>

<script>
import Slideout from 'vue-slideout'

export default {
  name: 'app',
  data() {
    return {
      appName: this.$appName
    }
  },
  components: {
    Slideout
  },
  methods: {
    open: function() {
      // console.log('slideoutOpen')
    }
  }
}
</script>

<style>
html {
  overflow-y: auto;
}

#menu {
  margin-top: 50px;
}

header {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  padding: 5px;
}

header h1 {
  margin: 0 auto;
}

.toggle-button {
  height: 40px;
  width: 40px;
  position: absolute;
  align-content: flex-start;
  margin: auto 0;
}

.slideout-menu {
  position: fixed;
  top: 0;
  bottom: 0;
  height: 100vh;
  padding: 10px;
  overflow-y: auto;
  -webkit-overflow-scrolling: touch;
  z-index: 0;
  display: none;
  color: white;
}

.slideout-menu-left {
  left: 0;
}

.slideout-menu-right {
  right: 0;
}

.slideout-panel {
  background-color: #4b5;
  color: white;
  position: relative;
  z-index: 1;
  will-change: transform;
  min-height: calc(100vh - 50px);
}

.slideout-open,
.slideout-open body,
.slideout-open .slideout-panel {
  overflow: hidden;
}

.slideout-open .slideout-menu {
  display: block;
}
</style>
