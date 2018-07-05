<template>
  <div>
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
        <b-table-column field="name" label="Name" sortable>
          {{ props.row.name }}
        </b-table-column>
        <b-table-column field="description" label="Description" sortable>
          {{ props.row.description }}
        </b-table-column>
        <b-table-column field="origin" label="Origin" sortable>
          {{ props.row.origin }}
        </b-table-column>
        <b-table-column field="type" label="Type" sortable>
          {{ props.row.type }}
        </b-table-column>
        <b-table-column field="created_at" label="Created At" sortable>
          {{ props.row.created_at | formatDate }}
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
