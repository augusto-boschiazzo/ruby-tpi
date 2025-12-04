import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    static targets = ["brand", "menu", "menuButton"];

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
        } else {
            this.updateState = this.updateState.bind(this);
            this.applyState(false);
            window.addEventListener("scroll", this.updateState, {
                passive: true,
            });
            window.addEventListener("resize", this.updateState);
            this.updateState();
        }

        this.menuOpen = false;
        if (this.hasMenuTarget) {
            this.handleDocumentClick = this.handleDocumentClick.bind(this);
            this.handleKeyDown = this.handleKeyDown.bind(this);
            document.addEventListener("click", this.handleDocumentClick);
            document.addEventListener("keydown", this.handleKeyDown);
            this.updateMenuVisibility();
        }
    }

    disconnect() {
        if (this.updateState) {
            window.removeEventListener("scroll", this.updateState);
            window.removeEventListener("resize", this.updateState);
        }
        if (this.hasMenuTarget) {
            document.removeEventListener("click", this.handleDocumentClick);
            document.removeEventListener("keydown", this.handleKeyDown);
        }
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

    toggleMenu(event) {
        if (!this.hasMenuTarget) return;
        event?.preventDefault();
        event?.stopPropagation();
        this.menuOpen = !this.menuOpen;
        this.updateMenuVisibility();
    }

    closeMenu() {
        if (!this.menuOpen) return;
        this.menuOpen = false;
        this.updateMenuVisibility();
    }

    updateMenuVisibility() {
        if (!this.hasMenuTarget) return;
        if (!this.menuTarget) return;
        if (this.menuOpen) {
            this.menuTarget.hidden = false;
            this.menuTarget.classList.remove(
                "pointer-events-none",
                "opacity-0",
                "-translate-y-2",
                "scale-95"
            );
            this.menuTarget.classList.add("opacity-100", "scale-100");
        } else {
            this.menuTarget.classList.add(
                "pointer-events-none",
                "opacity-0",
                "-translate-y-2",
                "scale-95"
            );
            this.menuTarget.classList.remove("opacity-100", "scale-100");
            this.menuTarget.hidden = true;
        }
        if (this.hasMenuButtonTarget) {
            this.menuButtonTarget.setAttribute(
                "aria-expanded",
                String(this.menuOpen)
            );
        }
    }

    handleDocumentClick(event) {
        if (!this.menuOpen) return;
        const withinMenu = this.menuTarget?.contains(event.target);
        const withinButton = this.menuButtonTarget?.contains(event.target);
        if (withinMenu || withinButton) return;
        this.closeMenu();
    }

    handleKeyDown(event) {
        if (event.key === "Escape") {
            this.closeMenu();
        }
    }
}
