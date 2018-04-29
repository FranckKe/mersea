<template>
  <!--<table class="table is-fullwidth is-striped is-narrow is-hoverable is-fullwidth">
    <tbody>
      <tr :key="idx" v-for="(tracer, idx) in tracersData()">
        <td>{{ tracer.name }}</td>
      </tr>
    </tbody>
  </table>-->
  <div class="container">
    <b-field grouped group-multiline>
      <b-select v-model="perPage">
        <option value="5">5 per page</option>
        <option value="10">10 per page</option>
        <option value="15">15 per page</option>
        <option value="20">20 per page</option>
      </b-select>
    </b-field>
    <b-table
      :data="tracersData()"
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
      </template>
    </b-table>
  </div>
</template>

<script>
export default {
  name: "tracers-list",
  props: ['tracers'],
  data() {
    return {
      tracersData: this.tracers,
      defaultSortDirection: 'asc',
      currentPage: 1,
      perPage: 10
    }
  }
}
</script>
