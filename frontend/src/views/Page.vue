<template>
  <div class="section">
    <div class="container">
      <div class="page" v-html="this.pageContent"></div>
    </div>
  </div>
</template>

<script>
import { createNamespacedHelpers } from 'vuex'
const { mapGetters } = createNamespacedHelpers('pages')

export default {
  name: 'page',
  props: ['category', 'page', 'pageId'],
  data() {
    return {
      pageContent: ''
    }
  },
  created() {
    this.getContent()
  },
  watch: {
    $route() {
      this.getContent()
    }
  },
  methods: {
    getContent: function() {
      this.pageContent = this.getPageContent({
        pageName: this.$props.page
      })
    }
  },
  computed: { ...mapGetters(['getPageContent']) }
}
</script>

<style>
.page {
  margin: auto;
  max-width: 650px;
  line-height: 1.6;
  font-size: 18px;
  color: #444;
  padding: 0 10px;
}
.page p {
  margin-bottom: 1rem;
}
h1,
h2,
h3,
h4,
h5,
h6 {
  color: #363636;
  font-size: 2rem;
  font-weight: 600;
  line-height: 1.125;
  margin-bottom: 1rem;
}
h1 {
  font-size: 3rem;
}
h2 {
  font-size: 2.5rem;
}
h3 {
  font-size: 2rem;
}
h4 {
  font-size: 1.5rem;
}
h5 {
  font-size: 1.25rem;
}
h6 {
  font-size: 1rem;
}
</style>
