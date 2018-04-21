<template>
  <section class="section">
    <h1>Tracers</h1>
    <div class="columns is-multiline is-mobile">
      <div class="column is-half-mobile is-one-third-tablet is-one-quarter-desktop" :key="idx" v-for="(tracer, idx) in tracers">
        <article class="card">
          <div class="card-image">
            <div class="img-wrapper" :style="'background-image: url(' + tracer.img + ')'">
            </div>
          </div>
          <div class="card-content">
            {{ tracer.title }}
          </div>
        </article>
      </div>
    </div>
  </section>
</template>


<script>
export default {
  name: 'tracers',
  data() {
    return {
      tracers: [
        {
          title: 'Hello1',
          content: 'Lorem ipsum lol',
          img: 'https://placeimg.com/1280/960/any'
        },
        {
          title: 'Hello2',
          content: 'Lorem ipsum lol',
          img: 'https://placeimg.com/1280/960/any'
        },
        {
          title: 'Hello3',
          content: 'Lorem ipsum lol',
          img: 'https://placeimg.com/1280/960/any'
        },
        {
          title: 'Hello4',
          content: 'Lorem ipsum lol',
          img: 'https://placeimg.com/1280/960/any'
        },
        {
          title: 'Hello5',
          content: 'Lorem ipsum lol',
          img: 'https://placeimg.com/1280/960/any'
        },
        {
          title: 'Hello6',
          content: 'Lorem ipsum lol',
          img: 'https://placeimg.com/1280/960/any'
        },
        {
          title: 'Hello7',
          content: 'Lorem ipsum lol',
          img: 'https://placeimg.com/1280/960/any'
        }
      ]
    }
  }
}
</script>
<style>
.card-image {
  height: 200px;
}

.img-wrapper {
  width: 100%;
  height: 100%;
  position: relative;
  float: left;
  background-position: 50% 50%;
  background-repeat: no-repeat;
  background-size: cover;
}
</style>
