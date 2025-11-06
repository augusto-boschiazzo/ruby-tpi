import { Controller } from "@hotwired/stimulus"

// Bloquea o habilita el campo de audio según el estado del producto
export default class extends Controller {
  static targets = ["status", "audioInput"]

  connect() {
    this.toggleAudioInput()
  }

  toggleAudioInput() {
    const isUsed = this.statusTarget.value === "used"
    this.audioInputTarget.disabled = !isUsed
    if (!isUsed) {
      this.audioInputTarget.value = "" // limpia el archivo si se cambia a "nuevo"
      this.audioInputTarget.style.backgroundColor = "gainsboro"
    } else {
      this.audioInputTarget.style.backgroundColor = ""
    }
  }
}