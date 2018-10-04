<template>
  <div class="section">
    <div class="container">
      <h1 class="title is-1">{{ $t('register') }}</h1>

      <b-message v-show="errors.length" :title="$tc('errors', errors.length)" type="is-danger">
        <ul>
          <li v-for="error in errors" v-bind:key="error">{{ error }}</li>
        </ul>
      </b-message>

      <form class="form-register"  v-on:submit.prevent="register()">
        <b-field :label="$t('name')">
          <b-input v-model="user.name"></b-input>
        </b-field>
        <b-field :label="$t('email')">
          <b-input type="email"
              v-model="user.email"
              maxlength="30">
          </b-input>
        </b-field>
        <b-field :label="$t('password')">
          <b-input type="password"
            v-model="user.password"
            password-reveal>
          </b-input>
        </b-field>
        <b-field :label="$t('password_confirmation')">
          <b-input type="password"
            v-model="user.password_confirmation"
            password-reveal>
          </b-input>
        </b-field>
        <div class="field">
          <b-checkbox v-model="rememberMe">{{ $t('remember_me') }}</b-checkbox>
        </div>
        <button type="submit" class="button is-success">{{ $t('register') }}</button>
      </form>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      context: 'register context',
      user: {
        name: '',
        email: '',
        password: '',
        password_confirmation: ''
      },
      autoLogin: true,
      rememberMe: false,
      errors: ''
    }
  },
  methods: {
    register() {
      this.$auth.register({
        data: {
          user: this.user
        },
        autoLogin: this.autoLogin,
        rememberMe: this.rememberMe,
        success: function() {
          this.$toast.open({
            message: this.$t('register_success'),
            duration: 5000,
            type: 'is-success'
          })
        },
        error: function(res) {
          this.$toast.open({
            message: this.$t('register_failure'),
            duration: 5000,
            type: 'is-danger'
          })
          this.errors = res.response.data.errors[0].metadata.reason.split('.')
        }
      })
    }
  }
}
</script>

<style>
.form-register {
  margin-bottom: 25px;
}
</style>

<i18n>
{
  "en": {
    "email": "Email",
    "errors": "Error | Errors",
    "name": "Name",
    "password_confirmation": "Password confirmation",
    "password": "Password",
    "register_failure": "Error during registration",
    "register_success": "Welcome! You have signed up successfully",
    "register": "Register",
    "remember_me": "Remember me"
  },
  "fr": {
    "email": "Email",
    "errors": "Erreur | Erreurs",
    "name": "Nom",
    "password_confirmation": "Confirmation mot de passe",
    "password": "Mot de passe",
    "register_failure": "Erreur lors de l'inscription",
    "register_success": "Bienvenue ! Votre compte a été créé",
    "register": "Inscription",
    "remember_me": "Se souvenir de moi"
  },
  "es": {
    "email": "Email",
    "errors": "Error | Errores",
    "name": "Nombre",
    "password_confirmation": "Confirmación de contraseña",
    "password": "Contraseña",
    "register_failure": "Error durante el inscripción",
    "register_success": "Bienvenido. Tu cuenta fue creada",
    "register": "Registrarse",
    "remember_me": "Recordarme"
  }
}
</i18n>
