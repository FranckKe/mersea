import { shallowMount, createLocalVue } from '@vue/test-utils'
import Menu from '@/components/MenuNav.vue'
import Vuex from 'vuex'
import pages from '../../src/store/modules/pages'
import Buefy from 'buefy'
import VueRouter from 'vue-router'

const localVue = createLocalVue()
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
    const wrapper = shallowMount(Menu, { store, localVue, router })
    expect(wrapper.html()).toMatchSnapshot()
  })
})
