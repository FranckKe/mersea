import "./assets/style.css"

import { createApp } from "vue"
import { createPinia } from "pinia"

import auth from "./plugins/auth"
import i18n from "./plugins/i18n"
import { options, primeVue } from "./plugins/prime-vue"
import toastService from "./plugins/toast-service"
import mapLibre from "./plugins/map-libre"

import App from "./App.vue"
import router from "./router"

const app = createApp(App)

app.use(createPinia())
app.use(router)
app.use(auth)
app.use(i18n)
app.use(primeVue, options)
app.use(toastService)
app.use(mapLibre)

app.mount("#app")
