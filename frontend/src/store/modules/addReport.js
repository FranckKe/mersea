const state = {
  data: [],
  loading: true,
  success: false,
  errors: [],
  isFormActive: false,
  coordinates: '',
  address: '',
  currentStep: ''
}
const getters = {
  getLoading: state => {
    return state.loading
  },
<<<<<<< HEAD
  getError: state => {
=======
  geterror: state => {
>>>>>>> 12b50ba... Add report creation
    return state.errors
  },
  getSuccess: state => {
    return state.success
  },
  getIsFormActive: state => {
    return state.isFormActive
  },
  getCoordinates: state => {
    return state.coordinates
  },
  getAddress: state => {
    return state.address
  },
  getCurrentStep: state => {
<<<<<<< HEAD
    return state.currentStep
=======
    return state.address
>>>>>>> 12b50ba... Add report creation
  }
}
const mutations = {
  updateSuccess: state => {
    state.success = true
    state.loading = false
    state.errors = []
  },
  updateError: (state, { errors }) => {
    state.errors = errors
    state.loading = false
  },
  setIsFormActive: (state, isFormActive) => {
    state.isFormActive = isFormActive
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