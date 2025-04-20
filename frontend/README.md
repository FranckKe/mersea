# frontend

This template should help get you started developing with Vue 3 in Vite.

## Recommended IDE Setup

[VSCode](https://code.visualstudio.com/) + [Volar](https://marketplace.visualstudio.com/items?itemName=Vue.volar) (and disable Vetur).

## Type Support for `.vue` Imports in TS

TypeScript cannot handle type information for `.vue` imports by default, so we replace the `tsc` CLI with `vue-tsc` for type checking. In editors, we need [Volar](https://marketplace.visualstudio.com/items?itemName=Vue.volar) to make the TypeScript language service aware of `.vue` types.

## Customize configuration

See [Vite Configuration Reference](https://vitejs.dev/config/).

## Project Setup

```sh
pnpm install
```

### Compile and Hot-Reload for Development

```sh
pnpm dev
```

### Type-Check, Compile and Minify for Production

```sh
pnpm build
```

### Run Unit Tests with [Vitest](https://vitest.dev/)

```sh
pnpm test:unit
```

### Run End-to-End Tests with [Playwright](https://playwright.dev)

```sh
# Install browsers for the first run
npx playwright install

# When testing on CI, must build the project first
pnpm build

# Runs the end-to-end tests
pnpm test:e2e
# Runs the tests only on Chromium
pnpm test:e2e --project=chromium
# Runs the tests of a specific file
pnpm test:e2e tests/example.spec.ts
# Runs the tests in debug mode
pnpm test:e2e --debug
```

### Lint with [ESLint](https://eslint.org/)

```sh
pnpm lint
```

## Resources

- [Axios](https://axios-http.com/) (API)
- [Day.js](https://day.js.org) (date management)
- [Pinia](https://pinia.vuejs.org/) (state management)
- [Playwright](https://playwright.dev) (E2E testing)
- [PrimeIcons](https://primevue.org/icons/#list)
- [PrimeVue](https://primevue.org/) (component library)
- [PrimeVue + TailwindCSS](https://tailwind.primevue.org/)
- [TailwindCSS](https://tailwindcss.com/)
- [Vitest](https://vitest.dev/) (unit testing)
- [Vue](https://vuejs.org/)
- [VueAuth](https://vue-auth3.js.org/)
- [VueI18n](https://vue-i18n.intlify.dev/)
- [Vuelidate](https://vuelidate-next.netlify.app/)
- [VueMapLibre](https://indoorequal.github.io/vue-maplibre-gl/)
- [VueRouter](https://router.vuejs.org/)
