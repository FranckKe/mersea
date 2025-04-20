<script setup lang="ts">
import { ref } from "vue"
import { useAuth } from "vue-auth3"
import useVuelidate from "@vuelidate/core"
import { email as emailValidator, required, sameAs } from "@vuelidate/validators"
import Button from "primevue/button"
import IftaLabel from "primevue/iftalabel"
import InputText from "primevue/inputtext"
import Message from "primevue/message"
import Password from "primevue/password"
import { useToast } from "primevue/usetoast"
import { capitalize } from "@/utils/string"
import Page from "@/components/Page.vue"

const auth = useAuth()
const toast = useToast()

const name = ref("")
const email = ref("")
const password = ref("")
const passwordConfirm = ref("")
const remember = ref(false)
const formErrors = ref([])

const vuelidateRules = {
  email: { required, emailValidator },
  name: { required },
  password: { required },
  passwordConfirm: { required, sameAs: sameAs(password) },
}
const vuelidate = useVuelidate(vuelidateRules, { email, name, password, passwordConfirm })

async function register() {
  formErrors.value = []

  const isFormValid = await vuelidate.value.$validate()
  if (!isFormValid) return

  auth
    .register({
      data: { email: email.value, password: password.value, name: name.value },
      staySignedIn: remember.value,
      autoLogin: true,
    })
    .then((request) => {
      console.log(request)
      // this.setLocale(request.data.language) // TODO indiquer la langue peut-être ?
      toast.add({ severity: "success", detail: "TODO phrase register success", life: 5000 })
    })
    .catch((error) => {
      console.error(error)
      toast.add({ severity: "error", detail: "TODO phrase register failure", life: 5000 })
      formErrors.value = error.response.data?.errors[0].metadata.reason.split(".")
    })
}
</script>

<template>
  <Page :title="capitalize($t('registration'))">
    <Message class="mb-12">{{ $t("registrationAdvice") }}</Message>

    <form class="flex flex-col gap-6">
      <IftaLabel>
        <InputText id="name" class="w-full" v-model="name" />
        <label for="name">{{ capitalize($t("name")) }}</label>
      </IftaLabel>

      <IftaLabel>
        <InputText id="email" class="w-full" v-model="email" />
        <label for="email">{{ capitalize($t("email")) }}</label>
      </IftaLabel>

      <IftaLabel>
        <Password
          id="password"
          class="w-full [&>*]:w-full"
          :toggle-mask="true"
          v-model="password"
        />
        <label for="password">{{ capitalize($t("password")) }}</label>
      </IftaLabel>

      <IftaLabel>
        <Password
          id="passwordConfirm"
          class="w-full [&>*]:w-full"
          :toggle-mask="true"
          :feedback="false"
          v-model="passwordConfirm"
        />
        <label for="passwordConfirm">{{ capitalize($t("passwordConfirm")) }}</label>
      </IftaLabel>

      <Button class="mt-12" @click="register">{{ capitalize($t("submit")) }}</Button>

      <Message severity="error" v-if="formErrors.length">
        <ul>
          <li v-for="error in formErrors" :key="error">{{ error }}</li>
        </ul>
      </Message>
    </form>
  </Page>
</template>
