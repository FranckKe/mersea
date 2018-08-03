<template>
  <div class="page" :key="this.page" v-html="this.pageContent"></div>
</template>

<script>
import { createNamespacedHelpers } from 'vuex'
const { mapGetters } = createNamespacedHelpers('pages')

export default {
  name: 'page',
  props: ['category', 'page'],
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
        category: this.$props.category,
        pageName: this.$props.page
      })
      // Not executed without this timeout
      setTimeout(function() {
        ;[
          ...document.querySelectorAll(
            '.page-container h1, .page-container h2, .page-container h3, .page-container h4, .page-container h5, .page-container h6'
          )
        ].forEach(header => {
          // Add bulma classes
          header.classList.add(`title`)
          header.classList.add(`is-${header.tagName[1]}`)
        })
      }, 1)
    }
  },
  computed: { ...mapGetters(['getPageContent']) }
}
</script>
<style>
.page {
  max-width: 740px;
  margin: auto;
}

.page-container p {
  margin-bottom: 1rem;
}
</style>
