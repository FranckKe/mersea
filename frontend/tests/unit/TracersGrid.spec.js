import VueTestUtils from '@vue/test-utils'
import TracersGrid from '@/components/TracersGrid.vue'
import Vuex from 'vuex'
import pages from '../../src/store/modules/pages'
import tracers from '../../src/store/modules/tracers'
import Buefy from 'buefy'
import VueRouter from 'vue-router'
import moment from 'moment'
import tracersData from './data/tracers'
import i18n from '../../src/i18n'

VueTestUtils.config.mocks.$t = key => key
VueTestUtils.config.mocks.$tc = (key, count) => (key, count)

const localVue = VueTestUtils.createLocalVue()
localVue.use(Buefy)
localVue.use(Vuex)
localVue.use(VueRouter)

localVue.filter('formatDate', value =>
  moment(String(value)).format('MM/DD/YYYY')
)

const router = new VueRouter()

describe('Page.vue', () => {
  let store

  beforeEach(() => {
    store = new Vuex.Store({
      modules: {
        pages: pages,
        tracers: tracers
      }
    })
  })

  it('matches snapshot', () => {
    const wrapper = VueTestUtils.shallowMount(TracersGrid, {
      localVue,
      store,
      router,
      i18n,
      propsData: {
        tracers: tracersData
      }
    })
    expect(wrapper.html()).toMatchSnapshot()
  })
})
