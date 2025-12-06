import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["status", "audioInput", "stockInput"]

  connect() {
    this.userChangedStatus = false
    this.updateUI()
  }

  // Se llama cuando cambia el select de status
  toggleAudioInput() {
    this.userChangedStatus = true

    const isUsed = this.statusTarget.value === "used"

    if (isUsed) {
      // Si pasa a usado → borrar stock
      this.stockInputTarget.value = ""
    }

    this.updateUI()
  }

  updateUI() {
    const isUsed = this.statusTarget.value === "used"

    this.audioInputTarget.disabled = !isUsed
    this.stockInputTarget.disabled = isUsed

    // Estilos opcionales
    this.audioInputTarget.style.backgroundColor = isUsed ? "" : "gainsboro"
    this.stockInputTarget.style.backgroundColor = isUsed ? "gainsboro" : ""
  }
}
