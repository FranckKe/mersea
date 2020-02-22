<template>
  <div>
    <p>Sort by</p>
    <div class="buttons">
      <button
        class="button is-primary"
        :class="{ 'is-active': sortFields[field].active }"
        v-for="field in Object.keys(sortFields)"
        :key="field"
        @click="sortTracersBy(field)"
      >
        {{ $t(field) | capitalize }} ({{
          `${orderText[sortFields[field]['type']][sortFields[field]['order']]}`
        }})
      </button>
    </div>
    <div
      v-for="(category, idt) in getCategories()"
      :key="idt"
      class="tracers-grid-wrapper"
    >
      <h2 class="category-title title is-2">{{ $t(category) }}</h2>
      <div class="tracers-grid columns is-multiline is-mobile">
        <div
          class="column is-full-mobile is-half-tablet is-one-third-desktop"
          :key="idx"
          v-for="(tracer, idx) in sortedTracers.filter(
            t => category === t.category
          )"
        >
          <TracerCard :tracer="tracer" />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { createNamespacedHelpers } from 'vuex'
const { mapGetters } = createNamespacedHelpers('tracers')
import TracerCard from '@/components/TracerCard'
const reportsModule = createNamespacedHelpers('reports')

export default {
  name: 'tracers-grid',
  props: ['tracers'],
  components: {
    TracerCard
  },
  data() {
    return {
      apiUrl: this.$apiUrl,
      sortedTracers: JSON.parse(JSON.stringify(this.tracers)),
      orderText: {
        text: {
          asc: 'A→Z',
          desc: 'Z→A'
        },
        num: {
          asc: '0→9',
          desc: '9→0'
        },
        date: {
          asc: `${this.$t('newest')}->${this.$t('oldest')}`,
          desc: `${this.$t('oldest')}->${this.$t('newest')}`
        }
      },
      sortFields: {
        name: {
          active: true,
          type: 'text',
          order: 'asc'
        },
        quantity: {
          active: false,
          type: 'num',
          order: 'asc'
        },
        distance_between_tracers: {
          active: false,
          type: 'num',
          order: 'asc'
        },
        created_at: {
          active: false,
          type: 'date',
          order: 'asc'
        },
        kind: {
          active: false,
          type: 'text',
          order: 'asc'
        },
        origin: {
          active: false,
          type: 'text',
          order: 'asc'
        }
      }
    }
  },
  methods: {
    ...mapGetters(['getTracers', 'getCategories']),
    ...reportsModule.mapGetters([
      'getReportCount',
      'getReportsEveryKilometers'
    ]),
    sortTracersBy: function(field, order) {
      if (order == null) {
        order = this.sortFields[field].order
        Object.keys(this.sortFields).map(
          k => (this.sortFields[k].order = 'asc')
        )
        this.sortFields[field].order = order === 'asc' ? 'desc' : 'asc'
      } else {
        this.sortFields[field].order = order
      }
      Object.keys(this.sortFields).map(
        k => (this.sortFields[k].active = k === field)
      )
      let modifier = this.sortFields[field].order === 'asc' ? 1 : -1

      if (field === 'quantity') {
        this.sortedTracers.sort((a, b) => {
          if (this.getReportCount()(a.id) < this.getReportCount()(b.id)) {
            return 0 - modifier
          } else if (
            this.getReportCount()(a.id) > this.getReportCount()(b.id)
          ) {
            return modifier
          } else {
            return 0
          }
        })
      }

      if (field === 'distance_between_tracers') {
        this.sortedTracers.sort((a, b) => {
          if (
            this.getReportsEveryKilometers()(a.id) <
            this.getReportsEveryKilometers()(b.id)
          ) {
            return 0 - modifier
          } else if (
            this.getReportsEveryKilometers()(a.id) >
            this.getReportsEveryKilometers()(b.id)
          ) {
            return modifier
          } else {
            return 0
          }
        })
      }

      this.sortedTracers.sort((a, b) => {
        if (a[field] < b[field]) {
          return 0 - modifier
        } else if (a[field] > b[field]) {
          return modifier
        } else {
          return 0
        }
      })
    }
  },
  watch: {
    tracers: function() {
      this.sortedTracers = JSON.parse(JSON.stringify(this.tracers))
      this.sortTracersBy('name', 'asc')
    }
  }
}
</script>

<style lang="scss" scoped>
.tracers-grid {
  width: 100%;
  margin-bottom: 1rem;
}

.tracers-grid-wrapper {
  margin-bottom: 1.75rem;
}

.category-title {
  text-transform: capitalize;
}
</style>

<i18n>
{
  "en": {
    "sort_by": "Sort by",
    "newest": "Newest",
    "oldest": "Oldest",
    "created_at": "Created at",
    "origin": "Origin",
    "quantity": "Reported quantity",
    "distance_between_tracers": "Distance between tracers",
    "name": "Name",
    "research": "Research",
    "drift": "Drift",
    "container": "Container",
    "archive": "Archive",
    "kind": "Type"
  },
  "fr": {
    "sort_by": "Trier par",
    "newest": "Récent",
    "oldest": "Ancient",
    "created_at": "Créé le",
    "origin": "Origine",
    "quantity": "Quantité signalée",
    "distance_between_tracers": "Distance entre traceurs",
    "name": "Nom",
    "research": "Recherche",
    "drift": "Dérive",
    "container": "Conteneur",
    "archive": "Archive",
    "kind": "Type"
  },
  "es": {
    "sort_by": "Ordenar por",
    "newest": "Reciente",
    "oldest": "Antiguo",
    "created_at": "Creado en",
    "origin": "Origen",
    "quantity": "Cantidad testificada",
    "distance_between_tracers": "Distancia entre trazadores",
    "name": "Apellido",
    "research": "Búsqueda",
    "drift": "Dériva",
    "container": "Envase",
    "archive": "Archivo",
    "kind": "Tipo"
  }
}
</i18n>
