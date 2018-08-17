import { shallowMount, createLocalVue } from '@vue/test-utils'
import Page from '@/views/Page.vue'
import Vuex from 'vuex'
import pages from '../../src/store/modules/pages'
import Buefy from 'buefy'

const localVue = createLocalVue()
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
    const wrapper = shallowMount(Page, { store, localVue })
    expect(wrapper.html()).toMatchSnapshot()
  })
})
