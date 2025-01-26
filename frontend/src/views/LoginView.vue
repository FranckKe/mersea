<script setup lang="ts">
import { ref } from "vue"
import { useAuth } from "vue-auth3"
import useVuelidate from "@vuelidate/core"
import { email as emailValidator, required } from "@vuelidate/validators"
import Button from "primevue/button"
import Card from "primevue/card"
import Checkbox from "primevue/checkbox"
import Divider from "primevue/divider"
import IftaLabel from "primevue/iftalabel"
import InputText from "primevue/inputtext"
import Password from "primevue/password"
import { useToast } from "primevue/usetoast"
import { capitalize } from "@/utils/string"
import Page from "@/components/Page.vue"

const auth = useAuth()
const toast = useToast()

const email = ref("")
const password = ref("")
const remember = ref(false)
const formErrors = ref([])

const vuelidateRules = {
  email: { required, emailValidator },
  password: { required },
}
const vuelidate = useVuelidate(vuelidateRules, { email, password })

async function logIn() {
  formErrors.value = []

  const isFormValid = await vuelidate.value.$validate()
  if (!isFormValid) return

  auth
    .login({
      auth: { username: email.value, password: password.value },
      staySignedIn: remember.value,
    })
    .then((request) => {
      console.log(request)
      // this.setLocale(request.data.language) // TODO
      toast.add({ severity: "success", detail: "TODO phrase login success", life: 5000 })
    })
    .catch((error) => {
      console.error(error)
      toast.add({ severity: "error", detail: "TODO phrase login failure", life: 5000 })
      // this.error = error.response.data.errors TODO error
    })
}
</script>

<template>
  <Page :title="capitalize($t('login'))">
    <form class="flex flex-col gap-6">
      <IftaLabel>
        <InputText id="email" class="w-full" v-model="email" />
        <label for="email">{{ capitalize($t("email")) }}</label>
      </IftaLabel>

      <IftaLabel>
        <Password
          id="password"
          class="w-full [&>*]:w-full"
          :toggle-mask="true"
          :feedback="false"
          v-model="password"
        />
        <label for="password">{{ capitalize($t("password")) }}</label>
      </IftaLabel>

      <div class="flex items-center">
        <Checkbox inputId="rememberMe" v-model="remember" binary />
        <label for="rememberMe" class="ml-2">{{ capitalize($t("rememberMe")) }}</label>
      </div>

      <Button class="mt-12" @click="logIn">{{ capitalize($t("submit")) }}</Button>
    </form>

    <Card class="mt-12 w-fit mx-auto text-center">
      <template #content>
        <p>
          Mot de passe oublié ?
          <router-link
            to="/forgotten-password"
            class="text-primary-300 underline-offset-4 hover:underline"
            >Réinitialisez-le</router-link
          >
        </p>
        <Divider />
        <p>
          Pas de compte ?
          <router-link to="/register" class="text-primary-300 underline-offset-4 hover:underline"
            >Inscrivez-vous</router-link
          >
        </p>
      </template>
    </Card>

    <Message severity="error" v-if="formErrors.length">
      <ul>
        <li v-for="error in formErrors" :key="error">{{ error }}</li>
      </ul>
    </Message>
  </Page>
</template>
