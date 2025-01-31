<script setup lang="ts">
import { ref } from "vue"
import { computed, onBeforeMount } from "vue"
import { RouterLink } from "vue-router"
import { useI18n } from "vue-i18n"
import MegaMenu from "primevue/megamenu"
import axios from "@/libs/axios"
import { capitalize } from "@/utils/string"
import LocaleSelect from "@/components/LocaleSelect.vue"
import type { Page } from "@/types"

const { locale, t } = useI18n()

const pages = ref<Page[]>([])

const items = computed(() => {
  if (!pages.value) return []
  return [
    { label: capitalize(t("home")), route: "/", root: true },
    { label: capitalize(t("tracers")), route: `/${t("tracers")}`, root: true },
    { label: capitalize(t("Contributions")), route: `/${t("contributions")}`, root: true },
    {
      label: capitalize(t("menu")),
      icon: "pi pi-link",
      root: true,
      items: [
        [
          {
            label: capitalize(t("about")),
            items: pages.value
              .filter((page) => page.language === locale.value && page.category === "about")
              .map((page) => ({ label: page.name, route: `/pages/${page.slug}` })),
          },
        ],
        [
          {
            label: capitalize(t("information")),
            items: pages.value
              .filter((page) => page.language === locale.value && page.category === "information")
              .map((page) => ({ label: page.name, route: `/pages/${page.slug}` })),
          },
        ],
        [
          {
            label: "Association",
            items: [
              {
                label: "ANSEL",
                url: "https://assoansel.jimdoweb.com/",
                icon: "pi pi-external-link",
              },
              {
                label: "Piksail",
                url: "https://piksail.fr",
                icon: "pi pi-external-link",
              },
            ],
          },
        ],
      ],
    },
  ]
})

// TODO update backend to only retrieve page slug name and such
onBeforeMount(() => {
  axios
    .get(`/pages`)
    .then((response) => {
      pages.value = response.data ?? []
    })
    .catch((error) => {
      console.error(error)
    })
})
</script>

<template>
  <header class="fixed z-10 w-full p-2">
    <MegaMenu :model="items">
      <template #item="{ item }">
        <router-link v-if="item.route" v-slot="{ href, navigate }" :to="item.route" custom>
          <a v-ripple :href="href" :class="item.root ? 'p-5' : 'p-3'" @click="navigate">
            <span :class="item.icon" />
            <span :class="item.icon ? 'ml-2' : 'ml-0'">{{ t(item.label) }}</span>
          </a>
        </router-link>
        <a
          v-else
          v-ripple
          :href="item.url"
          target="_blank"
          rel="noopener"
          class="cursor-pointer"
          :class="item.root ? 'p-5' : ''"
        >
          <span :class="item.icon" />
          <span :class="item.icon ? 'ml-2' : 'ml-0'">{{ item.label }}</span>
        </a>
      </template>
      <template #end>
        <div class="flex items-center gap-2">
          <router-link to="/login" class="p-5">{{ capitalize(t("account")) }}</router-link>
          <LocaleSelect />
        </div>
      </template>
    </MegaMenu>
  </header>
</template>
