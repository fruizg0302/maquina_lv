/**
 * MaquinaBreadcrumb Hook
 *
 * Responsive breadcrumb collapsing. Monitors container width and
 * hides middle items when they overflow, showing an ellipsis instead.
 */
export const MaquinaBreadcrumb = {
  mounted() {
    this.handleResize = this.handleResize.bind(this)
    window.addEventListener("resize", this.handleResize)
    this.handleResize()
  },

  destroyed() {
    window.removeEventListener("resize", this.handleResize)
  },

  handleResize() {
    const containerWidth = this.el.clientWidth
    const items = this.el.querySelectorAll("[data-breadcrumb-part='item']")
    const ellipsis = this.el.querySelector("[data-breadcrumb-part='ellipsis']")

    if (items.length < 3 || !ellipsis) return

    // Reset visibility
    if (ellipsis) ellipsis.classList.add("hidden")
    items.forEach((item) => item.classList.remove("hidden"))

    // Check if we need to collapse
    let totalWidth = 0
    items.forEach((item) => (totalWidth += item.offsetWidth))

    if (totalWidth > containerWidth) {
      if (ellipsis) ellipsis.classList.remove("hidden")

      // Hide middle items (keep first and last) until we fit
      for (let i = items.length - 2; i > 0; i--) {
        items[i].classList.add("hidden")

        totalWidth = ellipsis ? ellipsis.offsetWidth : 0
        items.forEach((item) => {
          if (!item.classList.contains("hidden")) {
            totalWidth += item.offsetWidth
          }
        })

        if (totalWidth <= containerWidth) break
      }
    }
  },
}
