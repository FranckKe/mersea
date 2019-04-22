<template>
  <div class="section">
    <div class="container">
      <h1 class="title is-1">{{ $t('register') }}</h1>
      <p>{{ $t('why_account') }}</p>
      <b-message
        v-show="formErrors.length"
        :title="$tc('errors', formErrors.length)"
        type="is-danger"
      >
        <ul>
          <li v-for="error in formErrors" v-bind:key="error">{{ error }}</li>
        </ul>
      </b-message>

      <form class="form-register" v-on:submit.prevent="register()">
        <b-field
          :label="$t('name')"
          :type="errors.has('username') ? 'is-danger' : ''"
          :message="errors.has('username') ? errors.first('username') : ''"
        >
          <b-input
            v-model="user.name"
            name="username"
            :data-vv-as="$t('name') | lowercase"
            v-validate="'required'"
          ></b-input>
        </b-field>
        <b-field
          :label="$t('email')"
          :type="errors.has('email') ? 'is-danger' : ''"
          :message="errors.has('email') ? errors.first('email') : ''"
        >
          <b-input
            type="email"
            v-model="user.email"
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
            type="password"
            v-model="user.password"
            name="password"
            ref="password"
            :data-vv-as="$t('password') | lowercase"
            v-validate="'required|min:6'"
            password-reveal
          ></b-input>
        </b-field>
        <b-field
          :label="$t('password_confirmation')"
          :type="errors.has('passwordConfirmation') ? 'is-danger' : ''"
          :message="
            errors.has('passwordConfirmation')
              ? errors.first('passwordConfirmation')
              : ''
          "
        >
          <b-input
            type="password"
            v-model="user.passwordConfirmation"
            name="passwordConfirmation"
            :data-vv-as="$t('password_confirmation') | lowercase"
            v-validate="'required|confirmed:password'"
            password-reveal
          ></b-input>
        </b-field>
        <div class="field">
          <b-checkbox v-model="rememberMe">{{ $t('remember_me') }}</b-checkbox>
        </div>
        <button type="submit" class="button is-success">
          {{ $t('register') }}
        </button>
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
        passwordConfirmation: ''
      },
      autoLogin: true,
      rememberMe: false,
      formErrors: []
    }
  },
  methods: {
    async register() {
      let validateForm = await this.$validator.validateAll()
      if (!validateForm) return false
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
          this.formErrors = res.response.data.errors[0].metadata.reason.split(
            '.'
          )
        }
      })
    }
  }
}
</script>

<style scoped>
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
    "remember_me": "Remember me",
    "why_account": "Creating an account allows you to manage your reports and to have part of the pre-filled report form."
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
    "remember_me": "Se souvenir de moi",
    "why_account": "La création d'un compte vous permet de gérer vos signalements et d'avoir une partie du formulaire de signalement pré-rempli."
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
    "remember_me": "Recordarme",
    "why_account": "Crear una cuenta le permite administrar sus informes y tener una parte del formulario de informe prellenado."
  }
}
</i18n>
