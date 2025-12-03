import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    static targets = ["slide", "indicator", "nextButton", "previousButton"];

    static values = {
        interval: { type: Number, default: 5000 },
        autoplay: { type: Boolean, default: false },
        loop: { type: Boolean, default: true },
        pauseOnHover: { type: Boolean, default: true },
    };

    connect() {
        this.currentIndex = 0;
        this.hovering = false;
        this.touchStartX = null;
        this.touchStartY = null;
        this.touchActive = false;

        if (this.slideTargets.length === 0) return;

        this.updateUI();
        this.startAutoplay();
    }

    disconnect() {
        this.stopAutoplay();
    }

    startAutoplay() {
        this.stopAutoplay();
        if (!this.autoplayValue || this.slideTargets.length <= 1) return;

        this.timer = window.setInterval(() => {
            if (this.pauseOnHoverValue && this.hovering) return;
            this.next();
        }, this.intervalValue);
    }

    stopAutoplay() {
        if (this.timer) {
            window.clearInterval(this.timer);
            this.timer = null;
        }
    }

    handleMouseEnter() {
        this.hovering = true;
        if (this.pauseOnHoverValue) this.stopAutoplay();
    }

    handleMouseLeave() {
        this.hovering = false;
        if (this.pauseOnHoverValue) this.startAutoplay();
    }

    onTouchStart(event) {
        if (this.slideTargets.length <= 1) return;
        const touch = event.touches?.[0];
        if (!touch) return;
        this.touchActive = true;
        this.touchStartX = touch.clientX;
        this.touchStartY = touch.clientY;
    }

    onTouchEnd(event) {
        if (!this.touchActive) return;
        this.touchActive = false;
        const touch = event.changedTouches?.[0];
        if (!touch) return;

        const dx = touch.clientX - this.touchStartX;
        const dy = touch.clientY - this.touchStartY;
        if (Math.abs(dx) > Math.abs(dy) && Math.abs(dx) > 36) {
            dx < 0 ? this.next() : this.previous();
        }
    }

    handleKey(event) {
        if (this.slideTargets.length <= 1) return;
        if (event.key === "ArrowRight") {
            event.preventDefault();
            this.next();
        } else if (event.key === "ArrowLeft") {
            event.preventDefault();
            this.previous();
        }
    }

    next() {
        this.goTo(this.currentIndex + 1);
    }

    previous() {
        this.goTo(this.currentIndex - 1);
    }

    go(event) {
        const index = event.params.index;
        if (index === undefined) return;
        this.goTo(Number(index));
    }

    goTo(index) {
        if (this.slideTargets.length === 0) return;

        const targetIndex = this.loopValue
            ? this.mod(index, this.slideTargets.length)
            : this.clamp(index);
        if (targetIndex === this.currentIndex) return;

        this.currentIndex = targetIndex;
        this.updateUI();

        if (this.autoplayValue) {
            this.startAutoplay();
        }
    }

    mod(value, divisor) {
        return ((value % divisor) + divisor) % divisor;
    }

    clamp(index) {
        return Math.max(0, Math.min(index, this.slideTargets.length - 1));
    }

    updateUI() {
        this.updateSlides();
        this.updateIndicators();
        this.updateButtons();
    }

    updateSlides() {
        this.slideTargets.forEach((slide, index) => {
            const isActive = index === this.currentIndex;
            slide.style.opacity = isActive ? "1" : "0";
            slide.style.pointerEvents = isActive ? "auto" : "none";
            slide.style.transform = isActive
                ? "translateX(0%)"
                : "translateX(0%)";
            slide.setAttribute("aria-hidden", isActive ? "false" : "true");
        });
    }

    updateIndicators() {
        if (!this.hasIndicatorTarget) return;
        this.indicatorTargets.forEach((indicator, index) => {
            const isActive = index === this.currentIndex;
            indicator.classList.toggle("bg-white", isActive);
            indicator.classList.toggle("bg-white/40", !isActive);
            indicator.style.transform = isActive ? "scale(1.25)" : "scale(1)";
            indicator.setAttribute("aria-current", isActive ? "true" : "false");
        });
    }

    updateButtons() {
        if (this.slideTargets.length <= 1) {
            if (this.hasNextButtonTarget)
                this.nextButtonTarget.classList.add("hidden");
            if (this.hasPreviousButtonTarget)
                this.previousButtonTarget.classList.add("hidden");
            return;
        }

        if (!this.loopValue) {
            if (this.hasNextButtonTarget) {
                this.nextButtonTarget.disabled =
                    this.currentIndex >= this.slideTargets.length - 1;
            }
            if (this.hasPreviousButtonTarget) {
                this.previousButtonTarget.disabled = this.currentIndex <= 0;
            }
        }
    }
}
