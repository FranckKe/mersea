import axios from "axios"

const instance = axios.create({
  baseURL: "https://alpha.oceanplastictracker.com", // TODO use env var
  timeout: 1000,
})

export default instance
