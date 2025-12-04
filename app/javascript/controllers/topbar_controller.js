import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    static targets = ["brand"];

    static values = {
        watchSelector: { type: String, default: "#acerca-de" },
        activeClass: { type: String, default: "text-white" },
        inactiveClass: { type: String, default: "text-(--accent)" },
    };

    connect() {
        if (!this.hasBrandTarget) return;
        this.section = document.querySelector(this.watchSelectorValue);

        if (!this.section) {
            this.applyState(false);
            return;
        }

        this.updateState = this.updateState.bind(this);
        this.applyState(false);
        window.addEventListener("scroll", this.updateState, { passive: true });
        window.addEventListener("resize", this.updateState);
        this.updateState();
    }

    disconnect() {
        window.removeEventListener("scroll", this.updateState);
        window.removeEventListener("resize", this.updateState);
    }

    updateState() {
        if (!this.section || !this.hasBrandTarget) return;
        const sectionRect = this.section.getBoundingClientRect();
        const headerHeight = this.element?.offsetHeight || 0;
        const isOverSection =
            sectionRect.top <= headerHeight &&
            sectionRect.bottom >= headerHeight;
        this.applyState(isOverSection);
    }

    applyState(isActive) {
        this.brandTargets.forEach((target) => {
            target.classList.toggle(this.activeClassValue, isActive);
            target.classList.toggle(this.inactiveClassValue, !isActive);
        });
    }
}
