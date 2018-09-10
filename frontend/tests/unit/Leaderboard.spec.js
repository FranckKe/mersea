import VueTestUtils from '@vue/test-utils'
import Leaderboard from '@/views/Leaderboard.vue'
import Vuex from 'vuex'
import Buefy from 'buefy'
import i18n from '../../src/i18n'

VueTestUtils.config.mocks.$t = key => key
VueTestUtils.config.mocks.$tc = (key, count) => (key, count)

const localVue = VueTestUtils.createLocalVue()
localVue.use(Buefy)
localVue.use(Vuex)

describe('Leaderboard.vue', () => {
  let store

  beforeEach(() => {
    store = new Vuex.Store()
  })

  it('matches snapshot', () => {
    const wrapper = VueTestUtils.shallowMount(Leaderboard, {
      localVue,
      store,
      i18n
    })
    expect(wrapper.html()).toMatchSnapshot()
  })
})
