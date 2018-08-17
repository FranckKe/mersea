import { shallowMount, createLocalVue } from '@vue/test-utils'
import Tracers from '@/views/Tracers.vue'
import Vuex from 'vuex'
import tracers from '../../src/store/modules/tracers'
import Buefy from 'buefy'
import { library } from '@fortawesome/fontawesome-svg-core'
import {
  faSearch,
  faThLarge,
  faThList
} from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
library.add(faSearch, faThList, faThLarge)

const localVue = createLocalVue()
localVue.use(Buefy)
localVue.use(Vuex)

localVue.component('font-awesome-icon', FontAwesomeIcon)

describe('Tracers.vue', () => {
  let store

  beforeEach(() => {
    store = new Vuex.Store({
      modules: {
        tracers: tracers
      }
    })
  })

  it('matches snapshot', () => {
    const wrapper = shallowMount(Tracers, { store, localVue })
    expect(wrapper.html()).toMatchSnapshot()
  })
})
