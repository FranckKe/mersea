import VueTestUtils from '@vue/test-utils'
import Tracers from '@/views/Tracers.vue'
import Vuex from 'vuex'
import tracers from '../../src/store/modules/tracers'
import Buefy from 'buefy'
import i18n from '../../src/i18n'
import { library } from '@fortawesome/fontawesome-svg-core'
import {
  faSearch,
  faThLarge,
  faThList
} from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
library.add(faSearch, faThList, faThLarge)

VueTestUtils.config.mocks.$t = key => key
VueTestUtils.config.mocks.$tc = (key, count) => (key, count)

const localVue = VueTestUtils.createLocalVue()
localVue.use(Buefy)
localVue.use(Vuex)

localVue.component('font-awesome-icon', FontAwesomeIcon)
localVue.filter('capitalize', function(value) {
  if (!value) return ''
  value = value.toString()
  return value.charAt(0).toUpperCase() + value.slice(1)
})

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
    const wrapper = VueTestUtils.shallowMount(Tracers, {
      localVue,
      store,
      i18n
    })
    expect(wrapper.html()).toMatchSnapshot()
  })
})
