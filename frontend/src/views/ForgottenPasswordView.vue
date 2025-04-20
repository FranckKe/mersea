<script setup lang="ts">
import { ref } from "vue"
import { useVuelidate } from "@vuelidate/core"
import { email as emailValidator, required } from "@vuelidate/validators"
import Button from "primevue/button"
import IftaLabel from "primevue/iftalabel"
import InputText from "primevue/inputtext"
import Message from "primevue/message"
import { useToast } from "primevue/usetoast"
import { capitalize } from "@/utils/string"
import axios from "@/libs/axios"
import Page from "@/components/Page.vue"

const toast = useToast()

const email = ref("")
const formErrors = ref([])

const vuelidateRules = {
  email: { required, emailValidator },
}
const vuelidate = useVuelidate(vuelidateRules, { email })

async function requestPasswordReset() {
  formErrors.value = []

  const isFormValid = await vuelidate.value.$validate()
  if (!isFormValid) return

  axios
    .post("/users/password", { user: { email: email.value } })
    .then(() => {
      toast.add({ severity: "success", detail: "TODO phrase login success", life: 5000 })
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
        <InputText id="email" class="w-full" v-model="email" required type="email" />
        <label for="email">{{ capitalize($t("email")) }}</label>
      </IftaLabel>

      <Button class="mt-12" @click="requestPasswordReset">{{ capitalize($t("submit")) }}</Button>

      <Message severity="error" v-if="formErrors.length">
        <ul>
          <li v-for="error in formErrors" :key="error">{{ error }}</li>
        </ul>
      </Message>
    </form>
  </Page>
</template>
