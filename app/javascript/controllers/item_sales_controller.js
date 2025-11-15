import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  static targets = ["container", "template", "price"]

  addItem() {
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime())
    this.containerTarget.insertAdjacentHTML("beforeend", content)
  }

  removeItem(event) {
    const item = event.target.closest(".nested-fields")
    item.querySelector("input[name*='_destroy']").value = "1"
    item.style.display = "none"
  }

  updatePrice(event) {
    const select = event.target
    const productId = select.value
    const priceField = select.closest(".nested-fields").querySelector("[data-item-sales-target='price']")
    if (!productId || !priceField) return

    fetch(`/products/${productId}.json`)
      .then(response => response.json())
      .then(data => {
        priceField.value = data.price
      })
  }
}