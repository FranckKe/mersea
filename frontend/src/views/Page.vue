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
      // Style html from backend with bulma
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
      }, 250)
    }
  },
  computed: { ...mapGetters(['getPageContent']) }
}
</script>

<style>
.page {
  margin:40px auto;
  max-width:650px;
  line-height:1.6;
  font-size:18px;
  color:#444;
  padding:0 10px
}
.page-container p {
  margin-bottom: 1rem;
}
h1, h2, h3{
  line-height: 1.2
}
</style>
