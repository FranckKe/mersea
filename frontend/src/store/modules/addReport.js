const state = {
  data: [],
  loading: true,
  success: false,
  errors: [],
  coordinates: '',
  address: '',
  currentStep: ''
}
const getters = {
  getLoading: state => {
    return state.loading
  },
  getError: state => {
    return state.errors
  },
  getSuccess: state => {
    return state.success
  },
  getCoordinates: state => {
    return state.coordinates
  },
  getAddress: state => {
    return state.address
  },
  getCurrentStep: state => {
    return state.currentStep
  }
}
const mutations = {
  setSuccess: state => {
    state.success = true
    state.loading = false
    state.errors = []
  },
  setError: (state, { errors }) => {
    state.errors = errors
    state.loading = false
  },
  setCoordinates: (state, coordinates) => {
    state.coordinates = coordinates
  },
  setAddress: (state, address) => {
    state.address = address
  },
  setCurrentStep: (state, currentStep) => {
    state.currentStep = currentStep
  }
}

export default {
  namespaced: true,
  state,
  getters,
  mutations
}
