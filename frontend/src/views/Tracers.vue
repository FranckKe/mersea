<template>
  <div class="section">
    <h1 class="heading_text is-size-3">Tracers</h1>
    <div class="field">
      <div class="control has-icons-left">
        <span class="icon is-small is-left">
          <font-awesome-icon icon="search" />
        </span>
        <input class="input" type="text" placeholder="Search for a tracer" v-model="searchKeywords">
      </div>
    </div>
    <div class="columns is-multiline is-mobile">
      <div class="column">
        <p class="has-text-left is-italic">{{ getFilteredTracers().length }} tracer{{ getFilteredTracers().length > 1 ? "s" : "" }} displayed ({{ this.tracers.length }} total)</p>
      </div>
      <div class="column buttons is-one-half-mobile is-one-quarter-tablet is-one-quarter-desktop has-text-right">
        <button class="button" v-bind:class="[this.tracersDisplayFormat === 'grid' ? 'is-primary' : '']" v-on:click="switchTo('grid')">
          <span class="icon is-small is-left">
            <font-awesome-icon icon="th-large" />
          </span>
        </button>
        <button class="button" v-bind:class="[this.tracersDisplayFormat === 'list' ? 'is-primary' : '']" v-on:click="switchTo('list')">
          <span class="icon is-small is-left">
            <font-awesome-icon icon="th-list" />
          </span>
        </button>
      </div>
    </div>
    <transition name="fade" mode="out-in">
      <tracers-grid v-if="this.tracersDisplayFormat === 'grid'" :tracers="getFilteredTracers"></tracers-grid>
      <tracers-list v-if="this.tracersDisplayFormat === 'list'" :tracers="getFilteredTracers"></tracers-list>
    </transition>
  </div>
</template>

<script>
import { mapState } from 'vuex'
import TracersGrid from '@/components/TracersGrid'
import TracersList from '@/components/TracersList'

export default {
  name: 'tracers',
  components: {
    TracersGrid,
    TracersList
  },
  data() {
    return {
      tracers: [],
      searchKeywords: ''
    }
  },
  async created() {
    await this.loadTracers()
  },
  methods: {
    switchTo(format) {
      this.$store.commit('updateTracersDisplayFormat', { format })
    },
    getFilteredTracers() {
      if (this.searchKeywords.trim() !== '') {
        let keywords = this.searchKeywords.toLowerCase()
        return this.tracers.filter(
          tracer => tracer.name.toLowerCase().indexOf(keywords) !== -1
        )
      } else {
        return this.tracers
      }
    },
    async loadTracers() {
      const tracers = await this.$http.get(`/tracers`)

      this.tracers = tracers.data
    }
  },
  computed: mapState(['tracersDisplayFormat'])
}
</script>
<style>
div.section {
  padding-top: 0;
}
.card-image {
  height: 200px;
}

.heading_text {
  margin-bottom: 1.5rem;
}

.img-wrapper {
  width: 100%;
  height: 100%;
  position: relative;
  float: left;
  background-position: 50% 50%;
  background-repeat: no-repeat;
  background-size: cover;
}
</style>
