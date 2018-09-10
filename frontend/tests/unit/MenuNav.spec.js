import VueTestUtils from '@vue/test-utils'
import Menu from '@/components/MenuNav.vue'
import Vuex from 'vuex'
import pages from '../../src/store/modules/pages'
import Buefy from 'buefy'
import VueRouter from 'vue-router'
import i18n from '../../src/i18n'

VueTestUtils.config.mocks.$t = key => key
VueTestUtils.config.mocks.$tc = (key, count) => (key, count)

const localVue = VueTestUtils.createLocalVue()
localVue.use(Buefy)
localVue.use(Vuex)
localVue.use(VueRouter)

const router = new VueRouter()

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
    const wrapper = VueTestUtils.shallowMount(Menu, {
      localVue,
      store,
      router,
      i18n
    })
    expect(wrapper.html()).toMatchSnapshot()
  })
})
