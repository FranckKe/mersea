<template>
  <section class="section">
    <div class="container">
      <b-field grouped group-multiline>
        <b-select v-model="perPage">
          <option value="5">5 per page</option>
          <option value="10">10 per page</option>
          <option value="15">15 per page</option>
          <option value="20">20 per page</option>
        </b-select>

        <div class="control is-flex">
          <input class="input" v-model="filter" type="search" placeholder="Search">
        </div>
      </b-field>

      <b-table
      :data="filtered"
      :paginated="true"
      :per-page="perPage"
      :current-page.sync="currentPage"
      :pagination-simple="false"
      :default-sort-direction="defaultSortDirection"
      default-sort="name">

      <template slot-scope="props">
        <b-table-column field="name" label="Name" width="40" sortable numeric>
          {{ props.row.name }}
        </b-table-column>

        <b-table-column field="reports_count" label="Number of reports" sortable>
          {{ props.row.reports_count }}
        </b-table-column>

        <b-table-column field="last_activity" label="Last activity" sortable centered>
          {{ props.row.last_activity }}
        </b-table-column>
      </template>
    </b-table>
  </div>
</section>
</template>

<script>
export default {
  data() {
    return {
      leaderboard: [],
      filter: '',
      defaultSortDirection: 'asc',
      currentPage: 1,
      perPage: 10
    }
  },
  mounted() {
    this.load()
  },
  methods: {
    load: async function() {
      try {
        await this.$http.get(`/leaderboard`).data
      } catch (e) {
        throw e
      }
    }
  },
  computed: {
    filtered: function() {
      this.filter = this.filter.toLowerCase()
      return this.leaderboard.filter(v => {
        return (
          v.name.toLowerCase().includes(this.filter) ||
          v.reports_count.toString().includes(this.filter) ||
          v.last_activity.includes(this.filter)
        )
      })
    }
  }
}
</script>

<style>
</style>
