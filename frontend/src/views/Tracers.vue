<template>
  <div class="section">
    <div class="container">
      <h1 class="title is-1">{{ $tc('tracers', 2) | capitalize }}</h1>
      <div class="field">
        <div class="control has-icons-left">
          <span class="icon is-small is-left">
            <font-awesome-icon icon="search" />
          </span>
          <input class="input" type="text" v-bind:placeholder="$t('search')" v-model="searchKeywords">
        </div>
      </div>
      <div class="columns is-multiline is-mobile">
        <div class="column">
          <p class="has-text-left is-italic">{{ getFilteredTracers().length }} {{ $tc('tracers', getFilteredTracers().length) }} {{ $tc('displayed', getFilteredTracers().length) }} ({{ this.tracers.length }} {{ $t('total') }})</p>
        </div>
        <div class="column buttons is-one-half-mobile is-one-quarter-tablet is-one-quarter-desktop has-text-right">
          <button class="button" v-bind:class="[this.displayFormat === 'grid' ? 'is-primary' : '']" v-on:click="setDisplayFormat('grid')">
            <span class="icon is-small is-left">
              <font-awesome-icon icon="th-large" />
            </span>
          </button>
          <button class="button" v-bind:class="[this.displayFormat === 'list' ? 'is-primary' : '']" v-on:click="setDisplayFormat('list')">
            <span class="icon is-small is-left">
              <font-awesome-icon icon="th-list" />
            </span>
          </button>
        </div>
      </div>
      <transition name="fade" mode="out-in">
        <tracers-grid v-if="this.displayFormat === 'grid'" :tracers="getFilteredTracers()"></tracers-grid>
        <tracers-list v-if="this.displayFormat === 'list'" :tracers="getFilteredTracers()"></tracers-list>
      </transition>
    </div>
  </div>
</template>

<script>
import { createNamespacedHelpers } from 'vuex'
const {
  mapState,
  mapMutations,
  mapGetters,
  mapActions
} = createNamespacedHelpers('tracers')
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
    try {
      await this.loadTracers()
    } catch (e) {
      this.$toast.open({
        message: this.$t('load_tracers_failure'),
        duration: 5000,
        type: 'is-danger'
      })
    }
    this.tracers = this.getData()
  },
  methods: {
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
    ...mapGetters(['getData']),
    ...mapMutations(['setDisplayFormat']),
    ...mapActions(['loadTracers'])
  },
  computed: {
    ...mapState({
      displayFormat: state => state.displayFormat,
      perPage: state => state.perPage
    })
  }
}
</script>
<style scoped>
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

<i18n>
{
  "en": {
    "tracers": "tracer | tracers",
    "search": "Search",
    "displayed": "displayed | displayed",
    "total": "total",
    "load_tracers_failure": "Failed to load tracers"
  },
  "fr": {
    "tracers": "tracer | tracers",
    "search": "Rechercher",
    "displayed": "affiché | affichés",
    "total": "en tout",
    "load_tracers_failure": "Échec de chargement des tracers"
  },
  "es": {
    "tracers": "trazadore | trazadores",
    "search": "Buscar",
    "displayed": "desplegado | desplegado",
    "total": "total",
    "load_tracers_failure": "Error al cargar los trazadores"
  }
}
</i18n>
