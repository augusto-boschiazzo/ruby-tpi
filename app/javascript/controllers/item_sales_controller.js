import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "template", "price", "total"]

  addItem() {
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime())
    this.containerTarget.insertAdjacentHTML("beforeend", content)
    this.updateTotal()
  }

  removeItem(event) {
    const item = event.target.closest(".nested-fields")
    const destroyField = item.querySelector("input[name*='_destroy']")
    if (destroyField) destroyField.value = "1"
    item.style.display = "none"
    this.updateTotal()
  }

  updatePrice(event) {
    const select = event.target
    const selectedOption = select.options[select.selectedIndex]
    const unitPrice = selectedOption?.dataset?.price

    const container = select.closest(".nested-fields")
    const priceField = container.querySelector("[data-item-sales-target='price']")

    if (unitPrice && priceField) {
      priceField.value = unitPrice
    }

    this.updateTotal()
  }

  updateTotal() {
    let total = 0

    this.containerTarget.querySelectorAll(".nested-fields").forEach(item => {
      const destroyField = item.querySelector("input[name*='[_destroy]']")
      if (destroyField && destroyField.value === "1") return

      const priceField = item.querySelector("[data-item-sales-target='price']")
      const quantityField = item.querySelector("input[name*='[quantity]']")

      if (!priceField || !quantityField) return

      const price = parseFloat(priceField.value || "0")
      const quantity = parseInt(quantityField.value || "0", 10)

      if (Number.isFinite(price) && Number.isFinite(quantity)) {
        total += price * quantity
      }
    })

    if (this.hasTotalTarget) {
      this.totalTarget.value = total.toFixed(2)
    }
  }
}