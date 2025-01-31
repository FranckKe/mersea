import { createAuth } from "vue-auth3"
import driverAuthBasic from "vue-auth3/drivers/auth/basic"
import driverHttpAxios from "vue-auth3/drivers/http/axios"
import router from "../router"

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
    url: "users",
    method: "POST",
    redirect: "/"
  },
  loginData: {
    url: "users/sign_in",
    method: "POST",
    redirect: "/"
  },
  logoutData: {
    url: "users/sign_out",
    method: "DELETE",
    redirect: "/",
    makeRequest: true
  },
  fetchData: {
    url: "users/me",
    method: "GET",
    enabled: true
  }
  //   refreshData: { // Deprecated, changed for refreshToken
  //     url: 'users/me',
  //     method: 'GET',
  //     enabled: false,
  //     interval: 30
  //   },
})

export default auth
