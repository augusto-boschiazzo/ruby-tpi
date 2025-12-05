import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    static targets = [
        "viewport",
        "track",
        "item",
        "nextButton",
        "previousButton",
    ];

    static values = {
        visible: { type: Number, default: 5 },
    };

    connect() {
        this.currentIndex = 0;
        this.visibleCount = this.visibleValue;
        this.refreshMetrics = this.refreshMetrics.bind(this);
        this.handleResize = this.handleResize.bind(this);
        this.handleScroll = this.handleScroll.bind(this);

        this.refreshMetrics();
        this.observeSizeChanges();

        window.addEventListener("resize", this.handleResize);
        if (this.hasViewportTarget) {
            this.viewportTarget.addEventListener("scroll", this.handleScroll, {
                passive: true,
            });
        }
    }

    disconnect() {
        window.removeEventListener("resize", this.handleResize);
        if (this.hasViewportTarget) {
            this.viewportTarget.removeEventListener(
                "scroll",
                this.handleScroll
            );
        }
        if (this.resizeObserver) {
            this.resizeObserver.disconnect();
            this.resizeObserver = null;
        }
    }

    observeSizeChanges() {
        if (!this.hasTrackTarget || typeof ResizeObserver === "undefined")
            return;
        this.resizeObserver = new ResizeObserver(() => this.refreshMetrics());
        this.resizeObserver.observe(this.trackTarget);
    }

    handleResize() {
        window.requestAnimationFrame(this.refreshMetrics);
    }

    handleScroll() {
        if (!this.hasViewportTarget || !this.slideDistance()) return;
        const index = Math.round(
            this.viewportTarget.scrollLeft / this.slideDistance()
        );
        if (index !== this.currentIndex) {
            this.currentIndex = Math.max(0, Math.min(index, this.maxIndex));
            this.updateButtons();
        }
    }

    refreshMetrics() {
        if (!this.hasViewportTarget) return;
        this.visibleCount = Math.max(1, Math.min(this.visibleValue, 5));
        this.itemWidth = this.measureItemWidth();
        this.itemGap = this.measureGap();
        this.maxIndex = Math.max(
            0,
            this.itemTargets.length - this.visibleCount
        );
        this.currentIndex = Math.min(this.currentIndex, this.maxIndex);
        this.applyScroll();
        this.updateButtons();
    }

    measureItemWidth() {
        const firstItem = this.itemTargets[0];
        if (!firstItem) return this.viewportTarget.clientWidth;
        return firstItem.getBoundingClientRect().width;
    }

    measureGap() {
        if (!this.hasTrackTarget) return 0;
        const styles = window.getComputedStyle(this.trackTarget);
        const columnGap = parseFloat(styles.columnGap || styles.gap || "0");
        return Number.isNaN(columnGap) ? 0 : columnGap;
    }

    slideDistance() {
        const width = this.itemWidth || 0;
        return width + (this.itemGap || 0);
    }

    next() {
        this.goTo(this.currentIndex + 1);
    }

    previous() {
        this.goTo(this.currentIndex - 1);
    }

    goTo(index) {
        if (!this.itemTargets.length) return;
        const targetIndex = Math.max(0, Math.min(index, this.maxIndex));
        if (targetIndex === this.currentIndex) return;
        this.currentIndex = targetIndex;
        this.applyScroll(true);
        this.updateButtons();
    }

    applyScroll(smooth = false) {
        if (!this.hasViewportTarget || !this.itemTargets.length) return;
        const distance = this.slideDistance();
        if (!distance) return;
        const offset = this.currentIndex * distance;
        this.viewportTarget.scrollTo({
            left: offset,
            behavior: smooth ? "smooth" : "auto",
        });
    }

    updateButtons() {
        const hideButtons = this.itemTargets.length <= this.visibleCount;
        if (this.hasPreviousButtonTarget) {
            this.toggleButtonState(
                this.previousButtonTarget,
                hideButtons,
                this.currentIndex <= 0
            );
        }
        if (this.hasNextButtonTarget) {
            this.toggleButtonState(
                this.nextButtonTarget,
                hideButtons,
                this.currentIndex >= this.maxIndex
            );
        }
    }

    toggleButtonState(button, hidden, disabled) {
        button.classList.toggle("opacity-0", hidden);
        button.classList.toggle("pointer-events-none", hidden);
        button.disabled = hidden || disabled;
        button.classList.toggle("opacity-40", disabled && !hidden);
    }
}
