import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["template", "container"]

  connect() {
    this.index = Date.now()
  }

  addItem(event) {
    event.preventDefault()
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, this.index++)
    this.containerTarget.insertAdjacentHTML("beforeend", content)
  }

  removeItem(event) {
    event.preventDefault()
    const wrapper = event.target.closest(".nested-fields")
    if (wrapper) {
      wrapper.remove()
    } else {
      const hiddenDestroy = event.target.closest("div").querySelector("input[name*='_destroy']")
      if (hiddenDestroy) {
        hiddenDestroy.value = "1"
        event.target.closest("div").style.display = "none"
      }
    }
  }
}
