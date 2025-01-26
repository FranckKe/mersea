<script setup lang="ts">
import { computed, onBeforeMount, ref } from "vue"
import { useI18n } from "vue-i18n"
import DataView from "primevue/dataview"
import IconField from "primevue/iconfield"
import InputIcon from "primevue/inputicon"
import IftaLabel from "primevue/iftalabel"
import InputText from "primevue/inputtext"
import SelectButton from "primevue/selectbutton"
import Tag from "primevue/tag"
import axios from "@/libs/axios"
import { capitalize, normalize } from "@/utils/string"
import Page from "@/components/Page.vue"
import type { Tracer } from "@/types"

const { locale } = useI18n()

const tracers = ref<Tracer[]>([])
const layout = ref<"grid" | "list">("grid")
const options = ref(["list", "grid"])

const search = ref("")

const filteredTracers = computed(() => {
  return search.value
    ? tracers.value.filter((tracer) => normalize(tracer.name).includes(normalize(search.value)))
    : tracers.value
})

onBeforeMount(() => {
  axios
    .get("/tracers")
    .then((response) => {
      tracers.value = response.data ?? []
      tracers.value.sort(
        (a, b) => new Date(b.created_at).valueOf() - new Date(a.created_at).valueOf(),
      )
    })
    .catch((error) => {
      console.error(error)
    })
})
</script>

<template>
  <Page :title="capitalize($t('tracers'))">
    <div class="flex flex-col gap-6 mb-12">
      <p>{{ $t("tracerDescription1") }}</p>
      <p>{{ $t("tracerDescription2") }}</p>
    </div>
  </Page>

  <section class="max-w-screen-2xl mx-auto p-2">
    <div class="flex flex-col gap-6">
      <DataView :value="filteredTracers" :layout="layout">
        <template #header>
          <div class="flex flex-col">
            <IftaLabel class="w-full">
              <IconField>
                <InputIcon class="pi pi-search" />
                <InputText
                  id="search"
                  class="w-full"
                  v-model="search"
                  placeholder="Filter TODO translate label and placeholder"
                />
                <InputIcon
                  class="pi pi-times cursor-pointer hover:text-primary"
                  @click="search = ''"
                />
              </IconField>
              <label for="search">{{ capitalize($t("search")) }}</label>
              <p>
                <small class="italic text-sm text-surface-300"
                  >{{ filteredTracers.length }} {{ $t("tracers") }}</small
                >
              </p>
            </IftaLabel>
            <div class="flex justify-end h-fit">
              <SelectButton v-model="layout" :options="options" :allowEmpty="false">
                <template #option="{ option }">
                  <i :class="[option === 'list' ? 'pi pi-bars' : 'pi pi-table']" />
                </template>
              </SelectButton>
            </div>
          </div>
        </template>

        <template #list="slotProps">
          <div class="flex flex-col">
            <div
              v-for="(item, index) in slotProps.items"
              :key="index"
              class="grid grid-cols-12 w-full"
              :class="{ 'border-t border-surface-700': index !== 0 }"
            >
              <div class="col-span-4 flex flex-col sm:flex-row sm:items-center p-6 gap-4">
                <div class="md:w-40">
                  <img
                    class="block xl:block mx-auto rounded w-full"
                    :src="`https://alpha.oceanplastictracker.com${item.photo}`"
                    :alt="item.name"
                  />
                  <!-- TODO use env var for apiurl -->
                </div>
                <div class="flex flex-col md:flex-row md:items-center flex-1 gap-6">
                  <div class="flex flex-row md:flex-col items-start gap-2">
                    <div>
                      <span class="text-surface-400 text-sm">{{ item.category }}</span>
                      <div class="text-lg font-semibold mt-2">{{ item.name }}</div>
                    </div>
                    <div
                      class="bg-surface-600 flex items-center gap-2 justify-center py-1 px-2 rounded"
                    >
                      <span class="text-sm">33 TODO getCOunt()</span>
                      <i class="pi pi-exclamation-circle"></i>
                    </div>
                  </div>
                </div>
              </div>
              <div class="col-span-4 flex flex-col gap-8 p-6 justify-center">
                <div class="flex flex-col gap-4">
                  <div class="flex flex-col gap-0 text-sm">
                    <span class="text-surface-400">Origine</span><span>{{ item.origin }}</span>
                  </div>
                  <div class="flex flex-col gap-0 text-sm">
                    <span class="text-surface-400">Distance entre traceurs</span
                    ><span>{{ item.origin }}</span>
                  </div>
                </div>
              </div>
              <div class="col-span-4 flex flex-col gap-8 p-6 justify-center">
                <div class="flex flex-col gap-0 text-sm">
                  <span class="text-surface-400">{{ capitalize($t("createdAt")) }}</span
                  ><span>{{
                    new Date(item.created_at).toLocaleDateString(locale, {
                      year: "numeric",
                      month: "long",
                      day: "numeric",
                    })
                  }}</span>
                </div>
                <div class="flex flex-col gap-0 text-sm">
                  <span class="text-surface-400">Description</span>
                  <p class="">
                    {{ item.description }}
                  </p>
                </div>
              </div>
            </div>
          </div>
        </template>

        <template #grid="slotProps">
          <div class="grid grid-cols-12 gap-4">
            <div
              v-for="(item, index) in slotProps.items"
              :key="index"
              class="col-span-12 sm:col-span-6 lg:col-span-4 xl:col-span-4 p-2"
            >
              <div class="flex flex-col h-full border border-surface-600 rounded p-6 shadow">
                <div class="mx-auto">
                  <img
                    class="rounded w-full max-w-[300px]"
                    :src="`https://alpha.oceanplastictracker.com${item.photo}`"
                    :alt="item.name"
                  />
                  <!-- TODO use env var for apiurl -->
                </div>
                <div class="pt-6">
                  <div class="flex flex-row justify-between items-center gap-2">
                    <div class="text-surface-400 text-sm">{{ item.category }}</div>
                    <div
                      class="bg-surface-600 flex items-center gap-2 justify-center py-1 px-2 rounded"
                    >
                      <span class="text-sm">33 TODO getCOunt()</span>
                      <i class="pi pi-exclamation-circle"></i>
                    </div>
                  </div>

                  <div class="flex flex-row justify-between items-start gap-2">
                    <div>
                      <div class="text-2xl font-semibold mt-5">{{ item.name }}</div>
                      <Tag severity="secondary" class="!text-xs !p-1 mt-3">{{ item.kind }}</Tag>
                      <p class="leading-tight text-surface-200 mt-5">
                        <small>{{ item.description }}</small>
                      </p>
                    </div>
                  </div>

                  <div class="flex flex-col gap-4 mt-8 text-sm">
                    <div>
                      <span class="text-surface-400">Origine&nbsp;:</span
                      ><span class="ml-2">{{ item.origin }}</span>
                    </div>
                    <div>
                      <span class="text-surface-400">Distance entre traceurs&nbsp;:</span
                      ><span class="ml-2">{{ item.origin }}</span>
                    </div>
                  </div>
                  <div class="text-right text-xs mt-8">
                    {{ capitalize($t("createdAt")) }}
                    {{
                      new Date(item.created_at).toLocaleDateString(locale, {
                        year: "numeric",
                        month: "long",
                        day: "numeric",
                      })
                    }}
                  </div>
                </div>
              </div>
            </div>
          </div>
        </template>
      </DataView>
    </div>
  </section>
</template>
