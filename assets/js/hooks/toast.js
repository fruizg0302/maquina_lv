/**
 * MaquinaToast Hook
 *
 * Manages individual toast lifecycle:
 * - Auto-dismiss timer
 * - Pause on hover
 * - Dismiss animation
 */
export const MaquinaToast = {
  mounted() {
    this.duration = parseInt(this.el.dataset.duration || "5000", 10)
    this.dismissible =
      this.el.dataset.dismissible !== "false"
    this.timeoutId = null
    this.remainingTime = this.duration
    this.startTime = null

    this.handleMouseEnter = this.handleMouseEnter.bind(this)
    this.handleMouseLeave = this.handleMouseLeave.bind(this)

    this.el.addEventListener("mouseenter", this.handleMouseEnter)
    this.el.addEventListener("mouseleave", this.handleMouseLeave)

    // Close button
    const closeBtn = this.el.querySelector(
      "[data-toast-part='close']"
    )
    if (closeBtn) {
      closeBtn.addEventListener("click", () => this.dismiss())
    }

    // Start after enter animation
    requestAnimationFrame(() => {
      setTimeout(() => {
        this.el.dataset.state = "visible"
        this.startTimer()
      }, 200)
    })
  },

  destroyed() {
    this.clearTimer()
    this.el.removeEventListener("mouseenter", this.handleMouseEnter)
    this.el.removeEventListener("mouseleave", this.handleMouseLeave)
  },

  startTimer() {
    if (this.duration <= 0) return
    this.startTime = Date.now()
    this.timeoutId = setTimeout(() => this.dismiss(), this.remainingTime)
  },

  clearTimer() {
    if (this.timeoutId) {
      clearTimeout(this.timeoutId)
      this.timeoutId = null
    }
  },

  handleMouseEnter() {
    if (this.duration <= 0) return
    this.clearTimer()
    if (this.startTime) {
      const elapsed = Date.now() - this.startTime
      this.remainingTime = Math.max(0, this.remainingTime - elapsed)
    }
  },

  handleMouseLeave() {
    if (this.duration <= 0 || this.remainingTime <= 0) return
    this.startTimer()
  },

  dismiss() {
    this.clearTimer()
    this.el.dataset.state = "exiting"
    setTimeout(() => this.el.remove(), 150)
  },
}
