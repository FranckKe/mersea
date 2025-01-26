<script setup lang="ts">
import { computed, onBeforeMount, ref } from "vue"
import Column from "primevue/column"
import DataTable from "primevue/datatable"
import IconField from "primevue/iconfield"
import InputIcon from "primevue/inputicon"
import IftaLabel from "primevue/iftalabel"
import InputText from "primevue/inputtext"
import Page from "@/components/Page.vue"
import axios from "@/libs/axios"
import dayjs from "@/libs/dayjs"
import { capitalize, normalize } from "@/utils/string"
import type { User } from "@/types"

const leaderboard = ref<User[]>([])

const search = ref("")

const filteredLeaderboard = computed(() => {
  return search.value
    ? leaderboard.value.filter((user) => normalize(user.name).includes(normalize(search.value)))
    : leaderboard.value
})

onBeforeMount(() => {
  axios
    .get("/leaderboard")
    .then((response) => {
      leaderboard.value = response.data ?? []
      leaderboard.value.sort((a, b) => b.reports_count - a.reports_count)
    })
    .catch((error) => {
      console.error(error)
    })
})
</script>

<template>
  <Page :title="capitalize($t('contributions'))">
    <IftaLabel class="w-full">
      <IconField>
        <InputIcon class="pi pi-user" />
        <InputText
          id="search"
          class="w-full"
          v-model="search"
          :placeholder="capitalize($t('name'))"
        />
        <InputIcon class="pi pi-times cursor-pointer hover:text-primary" @click="search = ''" />
      </IconField>
      <label for="search">{{ capitalize($t("search")) }}</label>
      <p>
        <small class="italic text-sm text-surface-300"
          >{{ leaderboard?.length }} reporters TODO translate</small
        >
      </p>
    </IftaLabel>
    <DataTable :value="filteredLeaderboard">
      <Column field="name" :header="capitalize($t('name'))"></Column>
      <Column field="reports_count" :header="capitalize($t('reports'))"></Column>
      <Column field="last_activity" :header="capitalize($t('lastActivity'))">
        <template #body="slotProps">
          {{ dayjs(slotProps.data.last_activity).format("Do MMMM YYYY") }}
        </template>
      </Column>
    </DataTable>
  </Page>
</template>
