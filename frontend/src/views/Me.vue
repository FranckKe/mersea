<template>
  <section class="section">
    <div class="container">
      <h1 class="title is-1">{{ $t('my_account') }}</h1>
      <div class="container">
        <h2 class="title is-2">{{ $t('my_info') }}</h2>
        <b-message
          v-show="userInfo.formErrors.length"
          :title="$tc('errors', userInfo.formErrors.length)"
          type="is-danger"
        >
          <ul>
            <li v-for="error in userInfo.formErrors" v-bind:key="error">
              {{ error }}
            </li>
          </ul>
        </b-message>
        <form
          class="form-user-info"
          v-on:submit.prevent="updateUserInfo()"
          data-vv-scope="update-user-info"
        >
          <b-field
            :label="$t('name')"
            :type="errors.has('update-user-info.name') ? 'is-danger' : ''"
            :message="
              errors.has('update-user-info.name')
                ? errors.first('update-user-info.name')
                : ''
            "
          >
            <b-input
              v-model="userInfo.name"
              name="name"
              :data-vv-as="$t('name') | lowercase"
              v-validate="'required'"
            ></b-input>
          </b-field>
          <b-field
            :label="$t('email')"
            :type="errors.has('update-user-info.email') ? 'is-danger' : ''"
            :message="
              errors.has('update-user-info.email')
                ? errors.first('update-user-info.email')
                : ''
            "
          >
            <b-input
              type="email"
              v-model="userInfo.email"
              name="email"
              :data-vv-as="$t('email') | lowercase"
              v-validate="'required|email'"
            ></b-input>
          </b-field>
          <b-field
            :label="$t('language')"
            :type="errors.has('update-user-info.language') ? 'is-danger' : ''"
            :message="
              errors.has('update-user-info.language')
                ? errors.first('update-user-info.language')
                : ''
            "
          >
            <b-select v-model="userInfo.language">
              <option
                v-for="(language, i) in getAvailableLangs()"
                :key="`language${i}`"
                :value="language"
                >{{ $t(language) }}</option
              >
            </b-select>
          </b-field>
          <b-field
            :label="$t('current_password')"
            :type="
              errors.has('update-user-info.current_password') ? 'is-danger' : ''
            "
            :message="
              errors.has('update-user-info.current_password')
                ? errors.first('update-user-info.current_password')
                : ''
            "
          >
            <b-input
              type="password"
              v-model="userInfo.current_password"
              name="current_password"
              :data-vv-as="$t('current_password') | lowercase"
              v-validate="'required|min:6'"
              password-reveal
            ></b-input>
          </b-field>
          <div class="buttons">
            <button type="submit" class="button is-success">
              {{ $t('update') }}
            </button>
          </div>
        </form>
      </div>
      <div class="container">
        <h2 class="title is-2">{{ $t('my_password') }}</h2>
        <b-message
          v-show="userPassword.formErrors.length"
          :title="$tc('errors', userPassword.formErrors.length)"
          type="is-danger"
        >
          <ul>
            <li v-for="error in userPassword.formErrors" v-bind:key="error">
              {{ error }}
            </li>
          </ul>
        </b-message>
        <form
          class="form-user-password"
          v-on:submit.prevent="updateUserPassword()"
          data-vv-scope="update-user-password"
        >
          <b-field
            :label="$t('current_password')"
            :type="
              errors.has('update-user-password.current_password')
                ? 'is-danger'
                : ''
            "
            :message="
              errors.has('update-user-password.current_password')
                ? errors.first('update-user-password.current_password')
                : ''
            "
          >
            <b-input
              type="password"
              v-model="userPassword.current_password"
              name="current_password"
              :data-vv-as="$t('current_password') | lowercase"
              v-validate="'required|min:6'"
              password-reveal
            ></b-input>
          </b-field>
          <b-field
            :label="$t('new_password')"
            :type="
              errors.has('update-user-password.new_password') ? 'is-danger' : ''
            "
            :message="
              errors.has('update-user-password.new_password')
                ? errors.first('update-user-password.new_password')
                : ''
            "
          >
            <b-input
              type="password"
              v-model="userPassword.password"
              name="new_password"
              ref="new_password"
              :data-vv-as="$t('new_password') | lowercase"
              v-validate="'required|min:6'"
              password-reveal
            ></b-input>
          </b-field>
          <b-field
            :label="$t('new_password_confirmation')"
            :type="
              errors.has('update-user-password.password_confirmation')
                ? 'is-danger'
                : ''
            "
            :message="
              errors.has('update-user-password.password_confirmation')
                ? errors.first('update-user-password.password_confirmation')
                : ''
            "
          >
            <b-input
              type="password"
              v-model="userPassword.password_confirmation"
              name="new_password_confirmation"
              :data-vv-as="$t('new_password_confirmation') | lowercase"
              v-validate="'required|confirmed:new_password'"
              password-reveal
            ></b-input>
          </b-field>
          <div class="buttons">
            <button type="submit" class="button is-success">
              {{ $t('update') }}
            </button>
          </div>
        </form>
      </div>
      <div class="container">
        <h2 class="title is-2">{{ $t('delete_account') }}</h2>
        <b-message
          v-show="userDelete.formErrors.length"
          :title="$tc('errors', userDelete.formErrors.length)"
          type="is-danger"
        >
          <ul>
            <li v-for="error in userDelete.formErrors" v-bind:key="error">
              {{ error }}
            </li>
          </ul>
        </b-message>
        <div class="buttons is-right">
          <button class="button is-danger" @click="isUserDeleteModal = true">
            {{ $t('delete_account') }}
          </button>
        </div>
        <b-modal :active.sync="isUserDeleteModal" :width="720" scroll="keep">
          <div class="container user-deletion-modal">
            <h2 class="title is-2">{{ $t('are_you_sure') }}</h2>
            <p>{{ $t('deletion_information') }}</p>
            <p>{{ $t('thank_you_reports') }}</p>
            <div class="buttons is-right">
              <button class="button" @click="isUserDeleteModal = false">
                {{ $t('cancel_delete_account') }}
              </button>
              <button
                type="submit"
                class="button is-danger"
                @click="deleteUser()"
              >
                {{ $t('delete_account') }}
              </button>
            </div>
          </div>
        </b-modal>
      </div>
    </div>
  </section>
</template>

<script>
import { mapActions, mapGetters } from 'vuex'

export default {
  data() {
    return {
      isUserDeleteModal: false,
      userInfo: {
        name: this.$auth.user().name,
        email: this.$auth.user().email,
        current_password: '',
        language: this.$auth.user().language,
        formErrors: []
      },
      userPassword: {
        current_password: '',
        password: '',
        password_confirmation: '',
        formErrors: []
      },
      userDelete: {
        formErrors: []
      }
    }
  },
  mounted() {},
  methods: {
    ...mapGetters(['getAvailableLangs', 'getLang']),
    ...mapActions(['setLocale']),
    async updateUserInfo() {
      let validateForm = await this.$validator.validateAll('update-user-info')
      if (!validateForm) return false
      let updateUserInfoRes
      try {
        updateUserInfoRes = await this.$http({
          method: 'PATCH',
          url: `/users/me`,
          data: this.userInfo
        })

        this.$toast.open({
          message: this.$t('update_user_info_success'),
          duration: 5000,
          type: 'is-success'
        })

        if (this.getLang() !== updateUserInfoRes.data.language)
          this.setLocale(updateUserInfoRes.data.language)

        this.$auth.user(updateUserInfoRes.data)
      } catch (e) {
        this.$toast.open({
          message: this.$t('update_user_info_failure'),
          duration: 5000,
          type: 'is-danger'
        })
        this.userInfo.formErrors = e.response.data.errors[0].metadata.reason.split(
          '.'
        )
      }
    },
    async updateUserPassword() {
      this.userPassword.formErrors = []
      let validateForm = await this.$validator.validateAll(
        'update-user-password'
      )

      if (!validateForm) {
        // There is a bug in vee-validate with the "confirmed" feature when multiple form are present on the same page
        // We manually set an error message as a workaround
        this.userPassword.formErrors = [
          this.$t('current_password_present'),
          this.$t('double_check_password')
        ]
        return false
      }

      try {
        await this.$http({
          method: 'PATCH',
          url: `/users/update_password`,
          data: this.userPassword
        })

        this.$toast.open({
          message: this.$t('update_user_password_success'),
          duration: 5000,
          type: 'is-success'
        })
      } catch (e) {
        this.$toast.open({
          message: this.$t('update_user_password_failure'),
          duration: 5000,
          type: 'is-danger'
        })
        this.userPassword.formErrors = e.response.data.errors[0].metadata.reason.split(
          '.'
        )
      }
    },
    async deleteUser() {
      try {
        await this.$http({
          method: 'DELETE',
          url: `/users/me`
        })
        this.$router.push({ name: 'home' })
        this.$toast.open({
          message: this.$t('delete_user_success'),
          duration: 5000,
          type: 'is-success'
        })
      } catch (e) {
        this.$toast.open({
          message: this.$t('delete_user_failure'),
          duration: 5000,
          type: 'is-danger'
        })
        this.userDelete.formErrors = e.response.data.errors[0].metadata.reason.split(
          '.'
        )
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.form-user-info,
.form-user-password {
  margin-bottom: 25px;

  .buttons {
    justify-content: flex-end;
    align-items: center;
  }
}

.user-deletion-modal {
  width: auto;
  background-color: white;
  padding: 2rem;

  p {
    margin-bottom: 1rem;
  }
}
</style>

<i18n>
{
  "en": {
    "are_you_sure": "Please confirm the account deletion",
    "cancel_delete_account": "Do not delete my account",
    "current_password_present": "Current password required",
    "current_password": "Current password",
    "delete_account": "Delete my account",
    "delete_user_failure": "Error during account deletion",
    "delete_user_success": "Account deleted",
    "deletion_information": "The account will be deleted, it is not recoverable. Your reports will not be deleted but your name will not be associated with them any longer.",
    "double_check_password": "New password and its confirmation must match",
    "email": "Email",
    "en": "English",
    "errors": "Error | Errors",
    "es": "Español",
    "fr": "Français",
    "language": "Language",
    "my_account": "My account",
    "my_info": "My information",
    "my_password": "My password",
    "name": "Name",
    "new_password_confirmation": "New password confirmation",
    "new_password": "New Password",
    "thank_you_reports": "Thank you for caring about the environment and for your reports!",
    "update_user_info_failure": "Error during information update",
    "update_user_info_success": "Information updated",
    "update_user_password_failure": "Error during password update",
    "update_user_password_success": "Password updated",
    "update": "Update"
  },
  "fr": {
    "are_you_sure": "Veuillez confirmer la suppression de votre compte",
    "cancel_delete_account": "Ne pas supprimer mon compte",
    "current_password_present": "Mot de passe actuel requis",
    "current_password": "Mot de passe actuel",
    "delete_account": "Supprimer mon compte",
    "delete_user_failure": "Erreur lors de la suppression du compte",
    "delete_user_success": "Compte supprimé",
    "deletion_information": "Le compte va être supprimmé il ne sera pas possible de le récupérer. Vos signalements ne seront pas supprimés mais votre nom ne figurera plus sur ces signalements.",
    "double_check_password": "Le nouveau mot de passe et sa confirmation doivent correspondrent",
    "email": "Email",
    "en": "English",
    "errors": "Erreur | Erreurs",
    "es": "Español",
    "fr": "Français",
    "language": "Langage",
    "my_account": "Mon compte",
    "my_info": "Mes informations",
    "my_password": "Mon mot de passe",
    "name": "Nom",
    "new_password_confirmation": "Confirmation du nouveau mot de passe",
    "new_password": "Nouveau mot de passe",
    "thank_you_reports": "Merci de prendre du temps pour nettoyer l'environnement et pour vos signalements !",
    "update_user_info_failure": "Erreur lors de la mise à jour des informations",
    "update_user_info_success": "Informations mises à jour",
    "update_user_password_failure": "Erreur lors de la mise à jour du mot de passe",
    "update_user_password_success": "Mot de passe mis à jour",
    "update": "Mettre à jour"
  },
  "es": {
    "are_you_sure": "Por favor confirme la eliminación de su cuenta.",
    "cancel_delete_account": "No borrar mi cuenta",
    "current_password_present": "Contraseña actual requerida",
    "current_password": "Contraseña actual",
    "delete_account": "Borré mi cuenta",
    "delete_user_failure": "Error al eliminar la cuenta",
    "delete_user_success": "Account deleted",
    "deletion_information": "La cuenta será eliminada y no será posible recuperarla. Sus informes no se eliminarán, pero su nombre ya no aparecerá en estos informes.",
    "double_check_password": "La nueva contraseña y su confirmación deben coincidir",
    "email": "Email",
    "en": "English",
    "errors": "Error | Errores",
    "es": "Español",
    "fr": "Français",
    "language": "Idioma",
    "my_account": "Mi cuenta",
    "my_info": "Mi informacion",
    "my_password": "Mi contraseña",
    "name": "Nombre",
    "new_password_confirmation": "Nueva confirmación de contraseña",
    "new_password": "Nueva contraseña",
    "thank_you_reports": "Gracias por tomarse el tiempo de limpiar el medio ambiente y por sus informes!",
    "update_user_info_failure": "Error durante la actualización de la información",
    "update_user_info_success": "Informacion actualizada",
    "update_user_password_failure": "Error durante la actualización de la contraseña",
    "update_user_password_success": "Contraseña actualiza",
    "update": "Actualizar"
  }
}
</i18n>
