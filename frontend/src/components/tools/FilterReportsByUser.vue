<template>
  <div>
    <div class="title-wrapper">
      <h4 class="title is-4">{{ toolViewTitle }}</h4>
      <a @click="closeToolbar" class="button is-danger close-tool-button">
        <font-awesome-icon icon="times" />
      </a>
    </div>
    <b-field label="Enter some tags">
      <b-taginput
        v-model="chosenUsers"
        :data="filteredUsers"
        autocomplete
        ellipsis
        :allow-new="false"
        field="user.name"
        icon="label"
        placeholder="Chose a user"
        @typing="getFilteredUsers"
      ></b-taginput>
    </b-field>
    <button class="button is-primary" @click="chosenUsers = []">
      <span>{{ $t('remove_all') }}</span>
    </button>
    <pre style="max-height: 400px"><b>chosenUsers:</b>{{ chosenUsers }}</pre>
  </div>
</template>

<script>
import { createNamespacedHelpers } from 'vuex'
const tracersModule = createNamespacedHelpers('tracers')
const reportsModule = createNamespacedHelpers('reports')
const toolBarModule = createNamespacedHelpers('toolBar')

export default {
  name: 'filterReportsByUser',
  data() {
    return {
      isActive: false,
      apiUrl: this.$apiUrl,
      search: '',
      userTags: '',
      chosenUsers: [],
      filteredUsers: this.getUsers()
    }
  },
  computed: {
    ...tracersModule.mapMutations(['setFilteredTracers']),
    ...tracersModule.mapGetters(['getTracers', 'getFilteredTracers']),
    ...tracersModule.mapState({
      tracers: state => state.tracers,
      filteredTracers: state => state.filteredTracers
    }),
    filteredTracers: {
      set(value) {
        this.setFilteredTracers(value)
      },
      get() {
        return this.getFilteredTracers()
      }
    }
  },
  methods: {
    ...toolBarModule.mapGetters(['getActiveTool']),
    ...toolBarModule.mapActions(['toggleActiveComponent', 'closeToolbar']),
    ...reportsModule.mapGetters([
      'getReports',
      'getFilteredReports',
      'getUsers'
    ]),
    getFilteredUsers(text) {
      this.filteredUsers = this.getUsers().filter(option => {
        return (
          option.user.name
            .toString()
            .toLowerCase()
            .indexOf(text.toLowerCase()) >= 0
        )
      })
    },
    updateReports: async function() {
      try {
        await this.loadReports({
          reportedAtMin: this.getReportedAtMin(),
          reportedAtMax: this.getReportedAtMax()
        })
      } catch (e) {
        this.$toast.open({
          message: this.$t('load_reports_failure'),
          duration: 5000,
          type: 'is-danger'
        })
      }
    }
  },
  watch: {
    chosenUsers: function() {
      this.getFilteredReports()
      this.setFilteredTracers(this.getFilteredTracers.filter(t => t.user))
    }
  }
}
</script>

<style>
.filter-report-search {
  margin: 0.5em 0;
}

.legend-tracers {
  margin-bottom: 1.5em;
}

.legend-tracer {
  width: 100%;
  display: flex;
  align-items: center;
  padding-left: 0.5em;
  flex-direction: column;
  min-height: 25px;
}

.legend-tracer:hover {
  background-color: gainsboro;
}

.legend-tracer label {
  width: 100%;
  display: flex;
  height: 35px;
}

.legend-tracer .control-label {
  width: 100%;
  display: flex;
  align-items: center;
  flex-direction: row;
  text-transform: capitalize;
}

.legend-circle {
  width: 20px;
  height: 20px;
  display: flex;
  justify-content: center;
  align-items: center;
  margin-right: 0.5em;
}

.check-buttons {
  display: flex;
  align-items: center;
  margin-bottom: 0.5em;
  margin-top: -0.5em; /* Get margin only when elements are wrapped */
}

.check-buttons button {
  margin-top: 0.5em; /* Get margin only when elements are wrapped */
}

.check-buttons button:first-child {
  margin-right: 0.5em;
}

.close-filter-button {
  display: none;
}

@media only screen and (max-device-width: 1024px) {
  .legend-tracer label {
    height: 30px;
  }
  .legend-tracer .control-label {
    font-size: 0.9em;
  }
}
</style>

<i18n>
{
  "en": {
    "check_all": "Check all",
    "search": "Search",
    "remove_all": "Reset users",
    "uncheck_all": "Uncheck all"
  },
  "fr": {
    "check_all": "Tout cocher",
    "search": "Rechercher",
    "remove_all": "Reset utilisateurs",
    "uncheck_all": "Tout décocher"
  },
  "es": {
    "check_all": "Comprobar todo",
    "search": "Buscar",
    "remove_all": "Restablecer usuarios",
    "uncheck_all": "Desmarcar todo"
  }
}
</i18n>
