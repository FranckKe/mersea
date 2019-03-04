<template>
  <div class="section">
    <div class="container">
      <h1 class="title is-1">{{ $t('reset_password') }}</h1>

      <b-message
        v-show="formErrors.length"
        :title="$tc('errors', formErrors.length)"
        type="is-danger"
      >
        <ul>
          <li v-for="error in formErrors" v-bind:key="error">{{ error }}</li>
        </ul>
      </b-message>

      <form class="form-reset-password" v-on:submit.prevent="resetPassword()">
        <b-field
          :label="$t('password')"
          :type="errors.has('password') ? 'is-danger': ''"
          :message="errors.has('password') ? errors.first('password') : ''"
        >
          <b-input
            type="password"
            v-model="password"
            name="password"
            ref="password"
            :data-vv-as="$t('password')|lowercase"
            v-validate="'required|min:6'"
            password-reveal
          ></b-input>
        </b-field>
        <b-field
          :label="$t('password_confirmation')"
          :type="errors.has('passwordConfirmation') ? 'is-danger': ''"
          :message="errors.has('passwordConfirmation') ? errors.first('passwordConfirmation') : ''"
        >
          <b-input
            type="password"
            v-model="passwordConfirmation"
            name="passwordConfirmation"
            :data-vv-as="$t('password_confirmation')|lowercase"
            v-validate="'required|confirmed:password'"
            password-reveal
          ></b-input>
        </b-field>
        <div class="buttons">
          <button type="submit" class="button is-success">{{ $t('reset_password') }}</button>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      passwordConfirmation: '',
      password: '',
      formErrors: []
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
    async resetPassword() {
      let validateForm = await this.$validator.validateAll()
      if (!validateForm) return false
      let resetPasswordRes
      try {
        resetPasswordRes = await this.$http({
          method: 'PATCH',
          url: '/users/password',
          data: {
            user: {
              reset_password_token: this.$route.query.reset_password_token,
              password: this.password,
              password_confirmation: this.password_confirmation
            }
          }
        })

        this.$toast.open({
          message: this.$t('reset_success'),
          duration: 5000,
          type: 'is-success'
        })
        this.$router.push({ name: 'login' })
      } catch (e) {
        this.$toast.open({
          message: this.$t('reset_failure'),
          duration: 5000,
          type: 'is-danger'
        })
        this.formErrors = e.response.data.errors[0].metadata.reason.split('.')
      }
    }
  }
}
</script>

<style scoped>
.form-login {
  margin-bottom: 25px;
}
</style>

<i18n>
{
  "en": {
    "email": "Email",
    "errors": "Error | Errors",
    "login_already": "You are already signed in",
    "login": "Login",
    "reset_failure": "Error during reset",
    "reset_success": "Password reset",
    "password_confirmation": "Password confirmation",
    "password": "Password",
    "reset_password": "Reset password"
  },
  "fr": {
    "email": "Email",
    "errors": "Erreur | Erreurs",
    "login_already": "Vous êtes déjà connecté(e)",
    "login": "Connexion",
    "password_confirmation": "Confirmation de mot de passe",
    "password": "Mot de passe",
    "reset_failure": "Erreur lors de la réinitialisation",
    "reset_password": "Réinitialiser le mot de passe",
    "reset_success": "Mot de passe réinitialisé"
  },
  "es": {
    "email": "Email",
    "errors": "Error | Errores",
    "login_already": "Ya has iniciado sesión",
    "login": "Iniciar sesión",
    "reset_failure": "Error durante el reinicio",
    "reset_success": "Restablecer contraseña",
    "password_confirmation": "Confirmación de contraseña",
    "password": "Contraseña",
    "reset_password": "Restablecer la contraseña"
  }
}
</i18n>
