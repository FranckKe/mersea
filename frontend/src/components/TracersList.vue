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
      :data="tracers"
      :paginated="true"
      :per-page="perPage"
      :current-page.sync="currentPage"
      :pagination-simple="false"
      :default-sort-direction="defaultSortDirection"
      :opened-detailed="defaultOpenedDetails"
      default-sort="name"
      detailed
      detail-key="id">
      <template slot-scope="props">
        <b-table-column field="name" label="Name" sortable>
          {{ props.row.name }}
        </b-table-column>
        <b-table-column field="origin" label="Origin" sortable>
          {{ props.row.origin }}
        </b-table-column>
        <b-table-column field="kind" label="Type" sortable>
          {{ props.row.kind }}
        </b-table-column>
        <b-table-column field="created_at" label="Created At" sortable>
          {{ props.row.created_at | formatDate }}
        </b-table-column>
      </template>
      <template slot="detail" slot-scope="props">
        <article class="media">
            <figure class="media-left">
                <p class="image is-64x64">
                    <img :src="`${apiUrl}${props.row.photo}`">
                </p>
            </figure>
            <div class="media-content">
                <div class="content">
                    <p class="tracer-description">{{ props.row.description }}</p>
                </div>
            </div>
        </article>
      </template>
      <template slot="empty">
        <section class="section">
            <div class="content has-text-grey has-text-centered">
                <p>
                    <b-icon
                        icon="emoticon-sad"
                        size="is-large">
                    </b-icon>
                </p>
                <p>Nothing here.</p>
            </div>
        </section>
      </template>
    </b-table>
  </div>
</template>

<script>
import { createNamespacedHelpers } from 'vuex'
const { mapState, mapGetters, mapMutations } = createNamespacedHelpers(
  'tracers'
)

export default {
  name: 'tracers-list',
  props: ['tracers'],
  data() {
    return {
      apiUrl: this.$apiUrl,
      defaultSortDirection: 'asc',
      currentPage: 1,
      defaultOpenedDetails: [1]
    }
  },
  methods: {
    ...mapMutations(['setPerPage']),
    ...mapGetters(['getPerPage'])
  },
  computed: {
    ...mapState({
      perPage: state => state.perPage
    }),
    // Two-way Computed Property
    perPage: {
      set(value) {
        this.setPerPage(value)
      },
      get() {
        return this.getPerPage()
      }
    }
  }
}
</script>


<style>
.tracer-description {
  max-width: 700px;
}
</style>
