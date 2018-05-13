<template>
  <article class="media">
    <div class="media-left">
      <figure class="image is-64x64">
        <img v-bind:src="`${this.apiUrl}${tracerThumbUrl}`" alt="Image">
      </figure>
    </div>
    <div class="media-content">
      <div class="content">
        <p>
          <strong>{{ tracerName }}</strong>
          <br>
          <small>
            {{ userName }}
          </small>
          <br>
          <small>{{ reportedAt | formatDate }}</small>
        </p>
      </div>
    </div>
    <div class="media-right">
    </div>
  </article>
</template>

<script>
import moment from 'moment'

export default {
  data() {
    return {
      apiUrl: this.$apiUrl
    }
  },
  filters: {
    formatDate: function(value) {
      if (!value) return ''
      return moment(value).format('LL')
    }
  },
  props: ['tracerName', 'userName', 'reportedAt', 'tracerThumbUrl'],
  mounted() {},
  methods: {}
}
</script>

<style>
/* Style mapbox popup close button as Bulma close button */
.mapboxgl-popup-close-button {
  -webkit-appearance: none;
  background-color: rgba(10, 10, 10, 0.2);
  border: none;
  border-radius: 290486px;
  cursor: pointer;
  display: inline-block;
  flex-grow: 0;
  flex-shrink: 0;
  font-size: 0;
  height: 24px;
  max-height: 24px;
  max-width: 24px;
  min-height: 24px;
  min-width: 24px;
  width: 24px;
  outline: 0;
  vertical-align: top;
  position: absolute;
  top: 5px;
  right: 5px;
}

.mapboxgl-popup-close-button::before,
.mapboxgl-popup-close-button::after {
  background-color: #fff;
  content: '';
  display: block;
  left: 50%;
  position: absolute;
  top: 50%;
  -webkit-transform: translateX(-50%) translateY(-50%) rotate(45deg);
  transform: translateX(-50%) translateY(-50%) rotate(45deg);
  -webkit-transform-origin: center center;
  transform-origin: center center;
}

.mapboxgl-popup-close-button::before {
  height: 2px;
  width: 50%;
}

.mapboxgl-popup-close-button::after {
  height: 50%;
  width: 2px;
}

/* Style mapbox popup as Bulma .box */
.mapboxgl-popup-content {
  background-color: white;
  border-radius: 5px;
  -webkit-box-shadow: 0 2px 3px rgba(10, 10, 10, 0.1),
    0 0 0 1px rgba(10, 10, 10, 0.1);
  box-shadow: 0 2px 3px rgba(10, 10, 10, 0.1), 0 0 0 1px rgba(10, 10, 10, 0.1);
  color: #4a4a4a;
  display: block;
  padding: 1.25rem;
}
</style>
