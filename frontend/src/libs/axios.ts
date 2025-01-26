import axios from "axios"

const instance = axios.create({
  baseURL: import.meta.env.VITE_APP_API_URL, // TODO use env var
  timeout: 1000,
})

export default instance
