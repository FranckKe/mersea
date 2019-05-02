const state = {
  activeTool: 'Information'
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
  },
  closeToolbar({ commit }) {
    commit('setActiveTool', '')
  }
}

export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations
}
