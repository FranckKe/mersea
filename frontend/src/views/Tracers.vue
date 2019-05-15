<template>
  <div class="section">
    <div class="container">
      <h1 class="title is-1">{{ $tc('tracers', 2) | capitalize }}</h1>
      <div class="tracer-description">
        <p>{{ $t('tracer_description_part_1') }}</p>
        <p>{{ $t('tracer_description_part_2') }}</p>
      </div>
      <div class="field">
        <div class="control has-icons-left">
          <span class="icon is-small is-left">
            <font-awesome-icon icon="search" />
          </span>
          <input
            class="input"
            type="text"
            v-bind:placeholder="$t('search')"
            v-model="searchKeywords"
          />
        </div>
      </div>
      <div class="columns is-multiline is-mobile">
        <div class="column">
          <p class="has-text-left is-italic">
            {{ getFilteredTracers().length }}
            {{ $tc('tracers', getFilteredTracers().length) }}
            {{ $tc('displayed', getFilteredTracers().length) }} ({{
              this.getTracers().length
            }}
            {{ $t('total') }})
          </p>
        </div>
        <div
          class="column buttons is-one-half-mobile is-one-quarter-tablet is-one-quarter-desktop has-text-right"
        >
          <button
            class="button"
            v-bind:class="[this.displayFormat === 'grid' ? 'is-primary' : '']"
            v-on:click="setDisplayFormat('grid')"
          >
            <span class="icon is-small is-left">
              <font-awesome-icon icon="th-large" />
            </span>
          </button>
          <button
            class="button"
            v-bind:class="[this.displayFormat === 'list' ? 'is-primary' : '']"
            v-on:click="setDisplayFormat('list')"
          >
            <span class="icon is-small is-left">
              <font-awesome-icon icon="th-list" />
            </span>
          </button>
        </div>
      </div>
      <div class="tracers-body">
        <b-loading
          :is-full-page="false"
          :active.sync="this.getLoading()"
          :can-cancel="false"
        ></b-loading>
        <transition name="fade" mode="out-in">
          <tracers-grid
            v-if="this.displayFormat === 'grid'"
            :tracers="getFilteredTracers()"
          ></tracers-grid>
          <tracers-list
            v-if="this.displayFormat === 'list'"
            :tracers="getFilteredTracers()"
          ></tracers-list>
        </transition>
      </div>
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
      searchKeywords: ''
    }
  },
  async created() {},
  methods: {
    getFilteredTracers() {
      if (this.normalizedSearch !== '') {
        return this.getTracers().filter(
          tracer => tracer.name.toLowerCase().indexOf(searchKeywords) !== -1
        )
      } else {
        return this.getTracers()
      }
    },
    ...mapGetters(['getTracers', 'getLoading']),
    ...mapMutations(['setDisplayFormat']),
    ...mapActions(['loadTracers'])
  },
  computed: {
    ...mapState({
      displayFormat: state => state.displayFormat,
      perPage: state => state.perPage
    }),
    normalizedSearch: function() { return this.searchKeywords.trim().normalize('NFD').replace(/[\u0300-\u036f]/g, "")},
  }
}
</script>
<style lang="scss" scoped>
.tracer-description p {
  margin-bottom: 1rem;
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

.tracers-body {
  position: relative;
  display: flex;
  min-height: 100px;
  width: 100%;
}
</style>

<i18n>
{
  "en": {
    "tracers": "tracer | tracers",
    "search": "Search",
    "displayed": "displayed | displayed",
    "total": "total",
    "tracer_description_part_1": "Among plastic pollution, some waste tell a story. Thoses trackers allows to qualify and quantify pollution coming from lost in sea containers or dumping. Tracers proposed for the follow-up are chosen in a collaborative way between the associations and the observation network, according to some criteria (quantity found, localization of the reports, ...). ",
    "tracer_description_part_2": "Some tracers such as MacKesson syringes, Pullman slippers, Zp caps or HP printer cartridges come from containers dropped at sea. Other tracers have completely different origins such as lobster trap traps that come from North America. North or Pascual yogurt pots that come from Spanish ships. The list of tracers is evolutionary, which makes it possible to add new tracers in case of new discoveries. This was particularly the case in January 2018 with milk powder pots and their plastic pods following a loss of containers off Galicia.",
    "load_tracers_failure": "Failed to load tracers"
  },
  "fr": {
    "tracers": "traceur | traceurs",
    "search": "Rechercher",
    "displayed": "affiché | affichés",
    "total": "en tout",
    "tracer_description_part_1": "Parmi les pollutions plastiques, certains déchets racontent une histoire et permettent de suivre leur propagation. Ces traceurs permettent de qualifier et de quantifier une partie de la pollution en mer. Les traceurs ci-dessous sont choisis de manière collaborative entre les acteurs derrière le projet, en fonction de quelques critères (quantité retrouvé, localisation des signalements, ...). ",
    "tracer_description_part_2": "Certains traceurs comme les seringues MacKesson, les chaussons Pullman, les bouchons Zp ou les cartouches d’imprimantes HP proviennent de conteneurs tombés en mer. D'autres traceurs ont des origines complètement différentes comme les trappes de casiers à homards qui proviennent d'Amérique du Nord ou les pots de Yaourt Pascual qui proviennent de navires espagnols. La liste des traceurs est évolutive, ce qui permet d'ajouter de nouveaux traceurs en cas de nouvelles découvertes. Ce fut notamment le cas en Janvier 2018 avec les pots de lait en poudre et leurs dosettes en plastique suite à une perte de conteneurs au large de la Galice.",
    "load_tracers_failure": "Échec de chargement des tracers"
  },
  "es": {
    "tracers": "trazador | trazadores",
    "search": "Buscar",
    "displayed": "desplegado | desplegado",
    "total": "total",
    "tracer_description_part_1": "Entre la contaminación plástica, algunos residuos cuentan una historia. Los rastreadores Thoses permiten calificar y cuantificar la contaminación proveniente de la pérdida en contenedores marítimos o el vertido. Los marcadores propuestos para el seguimiento se eligen de forma colaborativa entre las asociaciones y la red de observación, según algunos criterios (cantidad encontrada, localización de los informes, ...).",
    "tracer_description_part_2": "Algunos trazadores como las jeringas MacKesson, las zapatillas Pullman, las tapas Zp o los cartuchos de impresora HP provienen de contenedores que se lanzan al mar. Otros trazadores tienen orígenes completamente diferentes, como las trampas para trampas de langosta que vienen de América del Norte. Ollas de yogur del norte o Pascual que provienen de barcos españoles. La lista de marcadores es evolutiva, lo que hace posible agregar nuevos marcadores en caso de nuevos descubrimientos. Este fue particularmente el caso en enero de 2018 con las ollas de leche en polvo y sus vainas de plástico después de la pérdida de contenedores fuera de Galicia.",
    "load_tracers_failure": "Error al cargar los trazadores"
  }
}
</i18n>
