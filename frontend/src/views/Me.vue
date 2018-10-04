<template>
  <section class="section">
    <div class="container">
    <h1 class="title is-1">{{ $t('my_account') }}</h1>
      <b-message :title="$t('wip')" type="is-warning">
        {{ $t('under_construction') }}
      </b-message>
      <form class="form-login" v-on:submit.prevent="">
        <b-field :label="$t('name')">
          <b-input type="text"
            v-model="user.name"
            disabled="disabled">
          </b-input>
        </b-field>
       <b-field :label="$t('email')">
          <b-input type="email"
            v-model="user.email"
            disabled="disabled">
          </b-input>
        </b-field>
       <b-field :label="$t('language')">
          <b-input
            :value="$t(user.language)"
            disabled="disabled">
          </b-input>
        </b-field>
      </form>
    </div>
</section>
</template>

<script>
export default {
  data() {
    return {
      user: {}
    }
  },
  mounted() {
    this.load()
  },
  methods: {
    load: async function() {
      try {
        let user = await this.$http.get(`/users/me`)
        this.user = user.data
      } catch (e) {
        throw e
      }
    }
  }
}
</script>

<i18n>
{
  "en": {
    "email": "Email",
    "en": "English",
    "es": "Spañish",
    "fr": "Français",
    "language": "Language",
    "my_account": "My account",
    "name": "Name",
    "under_construction":"This section is currently under construction",
    "wip": "Work in progress"
  },
  "fr": {
    "email": "Email",
    "en": "English",
    "es": "Spañish",
    "fr": "Français",
    "language": "Langage",
    "my_account": "Mon compte",
    "name": "Nom",
    "under_construction": "Cette section est en cours de construction",
    "wip": "Travaux en cours"
  },
  "es": {
    "email": "Email",
    "en": "English",
    "es": "Spañish",
    "fr": "Français",
    "language": "Idioma",
    "my_account": "Mi cuenta",
    "name": "Nombre",
    "under_construction": "Esta sección se encuentra en construcción",
    "wip": "Trabajo en progreso"
  }
}
</i18n>
