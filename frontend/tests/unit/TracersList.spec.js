import { shallowMount, createLocalVue } from '@vue/test-utils'
import TracersList from '@/components/TracersList.vue'
import Vuex from 'vuex'
import pages from '../../src/store/modules/pages'
import tracers from '../../src/store/modules/tracers'
import Buefy from 'buefy'
import VueRouter from 'vue-router'
import moment from 'moment'
import tracersData from './data/tracers'

const localVue = createLocalVue()
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
    const wrapper = shallowMount(TracersList, {
      store,
      localVue,
      router,
      propsData: {
        tracers: tracersData.tracers
      }
    })
    expect(wrapper.html()).toMatchSnapshot()
  })
})
