<template>
  <div class="section">
    <div class="container">
      <h1 class="title is-1">{{ $t('login') }}</h1>

      <b-message v-show="error.length" :title="$t('error')" type="is-danger">
        {{ error }}
      </b-message>

      <form class="form-login" v-on:submit.prevent="login()">
        <b-field
          :label="$t('email')"
          :type="errors.has('email') ? 'is-danger' : ''"
          :message="errors.has('email') ? errors.first('email') : ''"
        >
          <b-input
            v-model="email"
            type="email"
            name="email"
            :data-vv-as="$t('email') | lowercase"
            v-validate="'required|email'"
          ></b-input>
        </b-field>
        <b-field
          :label="$t('password')"
          :type="errors.has('password') ? 'is-danger' : ''"
          :message="errors.has('password') ? errors.first('password') : ''"
        >
          <b-input
            v-model="password"
            type="password"
            name="password"
            :data-vv-as="$t('password') | lowercase"
            v-validate="'required'"
            password-reveal
          ></b-input>
        </b-field>
        <div class="field">
          <b-checkbox v-model="rememberMe">{{ $t('remember_me') }}</b-checkbox>
        </div>
        <div class="buttons">
          <router-link to="/users/send_reset_password/" class="forgot-password">
            {{ $t('reset_password') }}
          </router-link>
          <button type="submit" class="button is-success">
            {{ $t('login') }}
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
import { mapActions } from 'vuex'

export default {
  data() {
    return {
      context: 'login context',
      email: '',
      password: '',
      rememberMe: false,
      error: ''
    }
  },
  created() {
    if (this.$auth.check()) {
      this.$toast.open({
        message: this.$t('login_already'),
        duration: 5000,
        type: 'is-success'
      })
      this.$router.push({ name: 'home' })
    }
  },
  methods: {
    ...mapActions(['setLocale']),
    async login() {
      let validateForm = await this.$validator.validateAll()
      if (!validateForm) return false

      this.$auth
        .login({
          auth: { username: this.email, password: this.password },
          rememberMe: this.rememberMe
        })
        .then(request => {
          this.setLocale(request.data.language)
        })
        .then(() => {
          this.$toast.open({
            message: this.$t('login_success'),
            duration: 5000,
            type: 'is-success'
          })
        })
        .catch(res => {
          this.$toast.open({
            message: this.$t('login_failure'),
            duration: 5000,
            type: 'is-danger'
          })
          this.error = res.response.data.errors
        })
    }
  }
}
</script>

<style lang="scss" scoped>
.form-login {
  margin-bottom: 25px;

  .buttons {
    justify-content: flex-end;
    align-items: center;

    .button {
      margin-bottom: 0;
    }

    .forgot-password {
      margin-right: 0.5em;
    }
  }
}
</style>

<i18n>
{
  "en": {
    "email": "Email",
    "error": "Error",
    "login_already": "You are already signed in",
    "login_failure": "Error during login",
    "login_success": "You are now logged in",
    "login": "Login",
    "password": "Password",
    "remember_me": "Remember me",
    "reset_password": "Forgot password?"
  },
  "fr": {
    "email": "Email",
    "error": "Erreur",
    "login_already": "Vous êtes déjà connecté(e)",
    "login_failure": "Erreur lors de la connection",
    "login_success": "Vous êtes maintenant connecté",
    "login": "Connexion",
    "password": "Mot de passe",
    "remember_me": "Se souvenir de moi",
    "reset_password": "Mot de passe oublié ?"
  },
  "es": {
    "email": "Email",
    "error": "Error",
    "login_already": "Ya has iniciado sesión",
    "login_failure": "Error durante el inicio de sesión",
    "login_success": "Iniciaste sesión correctamente",
    "login": "Iniciar sesión",
    "password": "Contraseña",
    "remember_me": "Recordarme",
    "reset_password": "¿Se te olvidó tu contraseña?"
  }
}
</i18n>
