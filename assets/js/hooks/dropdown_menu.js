/**
 * MaquinaDropdownMenu Hook
 *
 * Handles opening/closing dropdown menus with:
 * - Click to toggle
 * - Click outside to close
 * - Escape key to close
 * - Arrow key navigation within menu
 * - Focus management
 * - Animation states
 */
export const MaquinaDropdownMenu = {
  mounted() {
    this.isOpen = false
    this.autoClose =
      this.el.dataset.autoClose === "true"

    this.trigger = this.el.querySelector(
      "[data-dropdown-menu-part='trigger']"
    )
    this.content = this.el.querySelector(
      "[data-dropdown-menu-part='content']"
    )

    this.handleClickOutside = this.handleClickOutside.bind(this)
    this.handleKeydown = this.handleKeydown.bind(this)

    if (this.trigger) {
      this.trigger.addEventListener("click", (e) => {
        e.preventDefault()
        this.toggle()
      })
    }

    if (this.autoClose) {
      this.el.addEventListener("click", (e) => {
        if (!this.isOpen) return
        const item = e.target.closest(
          "[data-dropdown-menu-part='item']"
        )
        if (
          item &&
          !item.disabled &&
          item.getAttribute("aria-disabled") !== "true"
        ) {
          this.close()
        }
      })
    }
  },

  destroyed() {
    this.removeListeners()
  },

  toggle() {
    if (this.isOpen) {
      this.close()
    } else {
      this.open()
    }
  },

  open() {
    if (this.isOpen || !this.content) return

    this.isOpen = true
    this.el.dataset.state = "open"
    this.content.dataset.state = "open"
    this.content.hidden = false

    if (this.trigger) {
      this.trigger.setAttribute("aria-expanded", "true")
    }

    this.addListeners()

    requestAnimationFrame(() => {
      this.focusFirstItem()
    })
  },

  close() {
    if (!this.isOpen || !this.content) return

    this.content.dataset.state = "closing"

    setTimeout(() => {
      this.isOpen = false
      this.el.dataset.state = "closed"
      this.content.dataset.state = "closed"
      this.content.hidden = true

      if (this.trigger) {
        this.trigger.setAttribute("aria-expanded", "false")
        this.trigger.focus()
      }

      this.removeListeners()
    }, 100)
  },

  handleClickOutside(event) {
    if (!this.isOpen) return
    if (this.el.contains(event.target)) return
    this.close()
  },

  handleKeydown(event) {
    if (!this.isOpen) return

    switch (event.key) {
      case "Escape":
        event.preventDefault()
        this.close()
        break
      case "ArrowDown":
        event.preventDefault()
        this.focusNextItem()
        break
      case "ArrowUp":
        event.preventDefault()
        this.focusPreviousItem()
        break
      case "Home":
        event.preventDefault()
        this.focusFirstItem()
        break
      case "End":
        event.preventDefault()
        this.focusLastItem()
        break
      case "Tab":
        this.close()
        break
    }
  },

  get menuItems() {
    if (!this.content) return []
    return Array.from(
      this.content.querySelectorAll(
        '[data-dropdown-menu-part="item"]:not([disabled]):not([aria-disabled="true"])'
      )
    )
  },

  focusFirstItem() {
    const items = this.menuItems
    if (items.length > 0) items[0].focus()
  },

  focusLastItem() {
    const items = this.menuItems
    if (items.length > 0) items[items.length - 1].focus()
  },

  focusNextItem() {
    const items = this.menuItems
    if (items.length === 0) return
    const idx = items.indexOf(document.activeElement)
    const next = idx < items.length - 1 ? idx + 1 : 0
    items[next].focus()
  },

  focusPreviousItem() {
    const items = this.menuItems
    if (items.length === 0) return
    const idx = items.indexOf(document.activeElement)
    const prev = idx > 0 ? idx - 1 : items.length - 1
    items[prev].focus()
  },

  addListeners() {
    setTimeout(() => {
      document.addEventListener("click", this.handleClickOutside)
    }, 0)
    document.addEventListener("keydown", this.handleKeydown)
  },

  removeListeners() {
    document.removeEventListener("click", this.handleClickOutside)
    document.removeEventListener("keydown", this.handleKeydown)
  },
}
