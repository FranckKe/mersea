<template>
  <div id="app">
    <Slideout menu="#menu" panel="#panel" :toggleSelectors="['.toggle-button']" @on-open="open">
      <nav id="menu">
        <div>Menu</div>
        <aside class="menu">
          <p class="menu-label">
            General
          </p>
          <ul class="menu-list">
            <li>
              <a>Dashboard</a>
            </li>
            <li>
              <a>Customers</a>
            </li>
          </ul>
          <p class="menu-label">
            Administration
          </p>
          <ul class="menu-list">
            <li>
              <a>Team Settings</a>
            </li>
            <li>
              <a class="is-active">Manage Your Team</a>
              <ul>
                <li>
                  <a>Members</a>
                </li>
                <li>
                  <a>Plugins</a>
                </li>
                <li>
                  <a>Add a member</a>
                </li>
              </ul>
            </li>
            <li>
              <a>Invitations</a>
            </li>
            <li>
              <a>Cloud Storage Environment Settings</a>
            </li>
            <li>
              <a>Authentication</a>
            </li>
          </ul>
          <p class="menu-label">
            Transactions
          </p>
          <ul class="menu-list">
            <li>
              <a>Payments</a>
            </li>
            <li>
              <a>Transfers</a>
            </li>
            <li>
              <a>Balance</a>
            </li>
          </ul>
        </aside>
      </nav>
      <header>
        <nav class="navbar is-fixed-top" role="navigation" aria-label="main navigation">
          <div class="navbar-start">
            <div class="navbar-item">
              <button class="button toggle-button">☰</button>
            </div>
            <a class="navbar-item" href="#">
              Ocean Plastic Tracker
            </a>
          </div>
        </nav>
        <!--<div>
          <button class="navbar-burger toggle-button">☰</button>
        </div>-->
      </header>

      <main id="panel">
        <img src="./assets/logo.png" alt="Vue.js PWA">
        <router-view></router-view>
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
#panel {
  margin-top: 40px;
}

.slideout-menu {
  position: fixed;
  top: 0;
  bottom: 0;
  width: 100vw;
  height: 100vh;
  overflow-y: auto;
  -webkit-overflow-scrolling: touch;
  z-index: 0;
  display: none;
  background-color: #1d1f20;
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
  min-height: 100vh;
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
