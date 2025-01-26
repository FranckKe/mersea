<script setup lang="ts">
import Button from "primevue/button"
import IftaLabel from "primevue/iftalabel"
import InputText from "primevue/inputtext"
import Password from "primevue/password"
import { capitalize } from "@/utils/string"
</script>

<template>
  <!-- TODO use page compinent  -->
  <div class="max-w-screen-md mx-auto">
    <h1 class="text-4xl">{{ capitalize($t("login")) }}</h1>

    TODO dans cette vue c'est la vue compte où tu peux CRUD toi-même

    <form>
      <IftaLabel>
        <InputText id="email" class="w-full" />
        <label for="email">{{ capitalize($t("email")) }}</label>
      </IftaLabel>

      <IftaLabel>
        <Password id="password" class="w-full [&>*]:w-full" :toggle-mask="true" :feedback="false" />
        <label for="password">{{ capitalize($t("password")) }}</label>
      </IftaLabel>

      <!-- TODO Rememberme check -->

      <Button>{{ capitalize($t("submit")) }}</Button>
    </form>
  </div>
</template>
