/**
 * MaquinaMenuButton Hook
 *
 * Simple toggle + click-outside behavior for menu buttons.
 * Used primarily in sidebar menus.
 */
export const MaquinaMenuButton = {
  mounted() {
    this.button = this.el.querySelector(
      "[data-menu-button-part='button']"
    )
    this.content = this.el.querySelector(
      "[data-menu-button-part='content']"
    )
    this.isOpen = false

    this.handleClickOutside = this.handleClickOutside.bind(this)

    if (this.button) {
      this.button.addEventListener("click", () => this.toggle())
    }
  },

  destroyed() {
    document.removeEventListener("click", this.handleClickOutside)
  },

  toggle() {
    if (!this.content) return

    this.isOpen = !this.isOpen
    this.button.dataset.state = this.isOpen ? "open" : "closed"
    this.content.classList.toggle("hidden", !this.isOpen)

    if (this.isOpen) {
      setTimeout(() => {
        document.addEventListener("click", this.handleClickOutside)
      }, 100)
    } else {
      document.removeEventListener("click", this.handleClickOutside)
    }
  },

  handleClickOutside(event) {
    if (!this.isOpen) return
    if (this.el.contains(event.target)) return
    this.toggle()
  },
}
