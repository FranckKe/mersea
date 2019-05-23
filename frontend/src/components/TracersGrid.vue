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
    <div class="tracers-grid columns is-multiline is-mobile">
      <div
        class="column is-full-mobile is-half-tablet is-one-third-desktop"
        :key="idx"
        v-for="(tracer, idx) in sortedTracers"
      >
        <article class="card">
          <div class="card-image">
            <div
              class="img-wrapper image"
              :style="`background-image: url('${apiUrl}${tracer.photo}') `"
            ></div>
          </div>
          <div class="card-content">
            <div class="content">
              <p class="title is-4">{{ tracer.name }}</p>
              <p>{{ tracer.description }}</p>
              <p>
                <strong>{{ $t('origin') }}:</strong>
                {{ tracer.origin }}
              </p>
              <p>
                <strong>{{ $t('kind') }}:</strong>
                {{ tracer.kind }}
              </p>
              <p>
                <strong>{{ $t('created_at') }}:</strong>
                <time datetime="tracer.created_at | formatDate">
                  {{ tracer.created_at | formatDate }}
                </time>
              </p>
              <p>
                <strong>{{ $t('quantity') }}:</strong>
                {{ getReportCount()(tracer.id) }}
              </p>
            </div>
          </div>
        </article>
      </div>
    </div>
  </div>
</template>

<script>
import { createNamespacedHelpers } from 'vuex'
const reportsModule = createNamespacedHelpers('reports')

export default {
  name: 'tracers-grid',
  props: ['tracers'],
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
    ...reportsModule.mapGetters(['getReportCount']),
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
.img-wrapper {
  height: 254px;
  padding-top: 5px;
  background-repeat: no-repeat;
  background-position: center;
}

.card {
  height: 100%;
}

.card-content .content p {
  margin-bottom: 0.25em;
}

.tracers-grid {
  width: 100%;
}
</style>

<i18n>
{
  "en": {
    "created_at": "Created at",
    "origin": "Origin",
    "quantity": "Reported quantity",
    "name": "Name",
    "sort_by": "Sort by",
    "newest": "Newest",
    "oldest": "Oldest",
    "kind": "Type"
  },
  "fr": {
    "created_at": "Créé le",
    "origin": "Origine",
    "quantity": "Quantité signalée",
    "name": "Nom",
    "sort_by": "Trier par",
    "newest": "Récent",
    "oldest": "Ancient",
    "kind": "Type"
  },
  "es": {
    "created_at": "Creado en",
    "origin": "Origen",
    "quantity": "Cantidad testificada",
    "name": "Apellido",
    "sort_by": "Ordenar por",
    "newest": "Reciente",
    "oldest": "Antiguo",
    "kind": "Tipo"
  }
}
</i18n>
