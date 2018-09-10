import VueTestUtils from '@vue/test-utils'
import Page from '@/views/Page.vue'
import Vuex from 'vuex'
import pages from '../../src/store/modules/pages'
import Buefy from 'buefy'
import i18n from '../../src/i18n'

VueTestUtils.config.mocks.$t = key => key
VueTestUtils.config.mocks.$tc = (key, count) => (key, count)

const localVue = VueTestUtils.createLocalVue()
localVue.use(Buefy)
localVue.use(Vuex)

describe('Page.vue', () => {
  let store

  beforeEach(() => {
    store = new Vuex.Store({
      modules: {
        pages: pages
      }
    })
  })

  it('matches snapshot', () => {
    const wrapper = VueTestUtils.shallowMount(Page, {
      localVue,
      store,
      i18n
    })
    expect(wrapper.html()).toMatchSnapshot()
  })
})
