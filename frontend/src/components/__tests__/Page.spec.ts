import { describe, it, expect } from "vitest"

import { mount } from "@vue/test-utils"
import Page from "../Page.vue"

describe("Page", () => {
  it("renders properly", () => {
    const wrapper = mount(Page, { props: { title: "Title" } })
    expect(wrapper.text()).toContain("Title")
  })
})
