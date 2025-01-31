import { createAuth } from "vue-auth3"
import driverAuthBasic from "vue-auth3/drivers/auth/basic"
import driverHttpAxios from "vue-auth3/drivers/http/axios"
import router from "../router"

// It would be cleaner to pass the axios instance
// to avoid prepending import.meta.env.VITE_APP_API_URL
// for each endpoint
const baseUrl = import.meta.env.VITE_APP_API_URL

const auth = createAuth({
  plugins: {
    router
  },
  drivers: {
    auth: driverAuthBasic,
    http: driverHttpAxios
  },
  authRedirect: { name: "login" },
  tokenDefaultKey: "mersea_auth_token",
  registerData: {
    url: `${baseUrl}/users`,
    method: "POST",
    redirect: "/"
  },
  loginData: {
    url: `${baseUrl}/users/sign_in`,
    method: "POST",
    redirect: "/"
  },
  logoutData: {
    url: `${baseUrl}/users/sign_out`,
    method: "DELETE",
    redirect: "/",
    makeRequest: true
  },
  fetchData: {
    url: `${baseUrl}/users/me`,
    method: "GET",
    enabled: true
  }
  //   refreshData: { // TODO Deprecated, changed for refreshToken
  //     url: 'users/me',
  //     method: 'GET',
  //     enabled: false,
  //     interval: 30
  //   },
})

export default auth
