import { Controller } from "@hotwired/stimulus"

// Bloquea o habilita el campo de audio según el estado del producto
export default class extends Controller {
  static targets = ["status", "audioInput", "stockInput"]

  connect() {
    this.toggleAudioInput()
  }

  toggleAudioInput() {
    const isUsed = this.statusTarget.value === "used"
    this.audioInputTarget.disabled = !isUsed
    this.stockInputTarget.disabled = isUsed
    if (!isUsed) {
      this.audioInputTarget.value = "" // limpia el archivo si se cambia a "nuevo"
      this.audioInputTarget.style.backgroundColor = "gainsboro"
      this.stockInputTarget.value = ""
      this.stockInputTarget.style.backgroundColor = ""
    } else {
      this.stockInputTarget.value = ""
      this.stockInputTarget.style.backgroundColor = "gainsboro"
      this.audioInputTarget.style.backgroundColor = ""
    }
  }
}