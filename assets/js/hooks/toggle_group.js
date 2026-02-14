/**
 * MaquinaToggleGroup Hook
 *
 * Manages a group of toggle buttons with single or multiple selection.
 * Handles keyboard navigation (arrows, Home, End) and dispatches
 * change events to the server via pushEvent.
 */
export const MaquinaToggleGroup = {
  mounted() {
    this.type = this.el.dataset.type || "single"
    this.selected = JSON.parse(this.el.dataset.selected || "[]")
    this.syncItemStates()

    this.el.addEventListener("click", (e) => {
      const item = e.target.closest("[data-toggle-group-part='item']")
      if (item && !item.disabled) this.toggle(item)
    })

    this.el.addEventListener("keydown", (e) => {
      const item = e.target.closest("[data-toggle-group-part='item']")
      if (item) this.handleKeydown(e, item)
    })
  },

  toggle(item) {
    const value = item.dataset.value
    const isPressed = item.dataset.state === "on"

    if (this.type === "single") {
      this.selected = isPressed ? [] : [value]
    } else {
      if (isPressed) {
        this.selected = this.selected.filter((v) => v !== value)
      } else {
        this.selected = [...this.selected, value]
      }
    }

    this.syncItemStates()
    this.dispatchChange()
  },

  handleKeydown(event, item) {
    const items = Array.from(
      this.el.querySelectorAll(
        "[data-toggle-group-part='item']:not([disabled])"
      )
    )
    const currentIndex = items.indexOf(item)
    let nextIndex = currentIndex

    switch (event.key) {
      case "ArrowRight":
      case "ArrowDown":
        event.preventDefault()
        nextIndex = (currentIndex + 1) % items.length
        break
      case "ArrowLeft":
      case "ArrowUp":
        event.preventDefault()
        nextIndex = (currentIndex - 1 + items.length) % items.length
        break
      case "Home":
        event.preventDefault()
        nextIndex = 0
        break
      case "End":
        event.preventDefault()
        nextIndex = items.length - 1
        break
      default:
        return
    }

    items[nextIndex]?.focus()
  },

  syncItemStates() {
    const items = this.el.querySelectorAll("[data-toggle-group-part='item']")
    items.forEach((item) => {
      const isSelected = this.selected.includes(item.dataset.value)
      item.dataset.state = isSelected ? "on" : "off"
      item.setAttribute("aria-pressed", isSelected)
    })
  },

  dispatchChange() {
    const detail = {
      type: this.type,
      value:
        this.type === "single" ? this.selected[0] || null : this.selected,
    }

    this.pushEvent("toggle-group:change", detail)

    this.el.dispatchEvent(
      new CustomEvent("toggle-group:change", { bubbles: true, detail })
    )
  },
}
