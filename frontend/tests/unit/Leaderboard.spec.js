import { shallowMount, createLocalVue } from '@vue/test-utils'
import Leaderboard from '@/views/Leaderboard.vue'
import Buefy from 'buefy'

const localVue = createLocalVue()
localVue.use(Buefy)

it('matches snapshot', () => {
  const wrapper = shallowMount(Leaderboard, { localVue })
  expect(wrapper.html()).toMatchSnapshot()
})
