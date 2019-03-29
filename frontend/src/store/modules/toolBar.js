const state = {
  activeTool: ''
}
const getters = {
  getActiveTool: state => {
    return state.activeTool
  }
}
const mutations = {
  setActiveTool: (state, activeTool) => {
    state.activeTool = activeTool
  }
}
const actions = {
  toggleActiveComponent({ commit, state }, activeTool) {
    commit('setActiveTool', state.activeTool === activeTool ? '' : activeTool)
  }
}

export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations
}
