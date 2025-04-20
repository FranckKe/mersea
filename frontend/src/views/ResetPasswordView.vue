<script setup lang="ts">
import { ref } from "vue"
import { useVuelidate } from "@vuelidate/core"
import { required, sameAs } from "@vuelidate/validators"
import Button from "primevue/button"
import IftaLabel from "primevue/iftalabel"
import InputText from "primevue/inputtext"
import Message from "primevue/message"
import { useToast } from "primevue/usetoast"
import { capitalize } from "@/utils/string"
import axios from "@/libs/axios"
import Page from "@/components/Page.vue"

const toast = useToast()

const password = ref("")
const passwordConfirm = ref("")
const formErrors = ref([])

// const token = query router todo

// TODO get reset password token and error message if undefined or expired?

const vuelidateRules = {
  password: { required },
  passwordConfirm: { required, sameAs: sameAs(password) },
}
const vuelidate = useVuelidate(vuelidateRules, { password, passwordConfirm })

async function resetPassword() {
  formErrors.value = []

  const isFormValid = await vuelidate.value.$validate()
  if (!isFormValid) return

  axios
    .patch("/users/password", {
      user: {
        reset_password_token: "token",
        password: password.value,
        password_confirm: passwordConfirm.value,
      },
    })
    .then(() => {
      toast.add({ severity: "success", detail: "TODO phrase login success", life: 5000 })
      // TODO redirect vers login
    })
    .catch((error) => {
      toast.add({ severity: "error", detail: "TODO phrase login failure", life: 5000 })
      formErrors.value = error.response.data.errors[0].metadata.reason.split(".")
    })
}
</script>

<template>
  <Page :title="capitalize($t('passwordReset'))">
    <form class="flex flex-col gap-6">
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

      <Button class="mt-12" @click="resetPassword">{{ capitalize($t("submit")) }}</Button>

      <Message severity="error" v-if="formErrors.length">
        <ul>
          <li v-for="error in formErrors" :key="error">{{ error }}</li>
        </ul>
      </Message>
    </form>
  </Page>
</template>
