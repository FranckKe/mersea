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
        <b-loading
          :is-full-page="false"
          :active.sync="isSendingEmail"
          :can-cancel="false"
        ></b-loading>
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
        <button type="submit" class="button is-success">
          {{ $t('reset_password') }}
        </button>
      </form>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      email: '',
      formErrors: [],
      isSendingEmail: false
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
      try {
        this.isSendingEmail = true
        await this.$http({
          method: 'POST',
          url: `/users/password`,
          data: { user: { email: this.email } }
        })

        this.isSendingEmail = false

        this.$toast.open({
          message: this.$t('reset_success'),
          duration: 5000,
          type: 'is-success'
        })

        this.$router.push({ name: 'home' })
      } catch (e) {
        this.isSendingEmail = false
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
    "reset_failure": "Error while sending reset password email",
    "reset_password": "Reset password",
    "reset_success": "Email sent"
  },
  "fr": {
    "email": "Email",
    "errors": "Erreur | Erreurs",
    "login_already": "Vous êtes déjà connecté(e)",
    "login": "Connexion",
    "reset_failure": "Erreur lors de l'envoi du mail de réinitialisation",
    "reset_password": "Réinitialiser le mot de passe",
    "reset_success": "Email envoyé"
  },
  "es": {
    "email": "Email",
    "errors": "Error | Errores",
    "login_already": "Ya has iniciado sesión",
    "login": "Iniciar sesión",
    "reset_failure": "Error while sending reset password email",
    "reset_password": "Restablecer la contraseña",
    "reset_success": "Email enviado"
  }
}
</i18n>
