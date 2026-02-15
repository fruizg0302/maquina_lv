/**
 * MaquinaCombobox Hook
 *
 * Handles autocomplete/search functionality with:
 * - HTML5 Popover API for light-dismiss
 * - Type-ahead filtering
 * - Single selection with toggle
 * - Keyboard navigation
 * - Focus management
 */
export const MaquinaCombobox = {
  mounted() {
    this.value = this.el.dataset.comboboxValue || ""
    this.name = this.el.dataset.comboboxName || ""
    this.placeholder = this.el.dataset.comboboxPlaceholder || "Select..."

    this.trigger = this.el.querySelector("[data-combobox-part='trigger']")
    this.content = this.el.querySelector("[data-combobox-part='content']")
    this.input = this.el.querySelector("[data-combobox-part='input']")
    this.emptyEl = this.el.querySelector("[data-combobox-part='empty']")
    this.labelEl = this.trigger
      ? this.trigger.querySelector("[data-combobox-part='label']")
      : null

    this.handlePopoverToggle = this.handlePopoverToggle.bind(this)
    this.handleContentKeydown = this.handleContentKeydown.bind(this)
    this.handleFilter = this.handleFilter.bind(this)
    this.handleOptionClick = this.handleOptionClick.bind(this)

    if (this.content) {
      this.content.addEventListener("toggle", this.handlePopoverToggle)
      this.content.addEventListener("keydown", this.handleContentKeydown)
    }

    if (this.input) {
      this.input.addEventListener("input", this.handleFilter)
      this.input.addEventListener("keydown", this.handleContentKeydown)
    }

    // Delegate click on options
    this.el.addEventListener("click", this.handleOptionClick)

    // Set initial selection
    if (this.value) {
      this.updateSelectionFromValue()
    }

    this.updateTriggerState()
  },

  destroyed() {
    if (this.content) {
      this.content.removeEventListener("toggle", this.handlePopoverToggle)
      this.content.removeEventListener("keydown", this.handleContentKeydown)
    }
    if (this.input) {
      this.input.removeEventListener("input", this.handleFilter)
      this.input.removeEventListener("keydown", this.handleContentKeydown)
    }
    this.el.removeEventListener("click", this.handleOptionClick)
  },

  handlePopoverToggle(event) {
    const isOpen = event.newState === "open"

    if (this.trigger) {
      this.trigger.setAttribute("aria-expanded", isOpen)
    }

    if (isOpen) {
      this.positionPopover()
      if (this.input) {
        requestAnimationFrame(() => {
          this.input.focus()
          this.input.value = ""
          this.resetFilter()
        })
      }
    }
  },

  positionPopover() {
    if (!this.trigger || !this.content) return

    const triggerRect = this.trigger.getBoundingClientRect()
    const align = this.content.dataset.align || "start"

    let left = triggerRect.left
    const top = triggerRect.bottom + 4

    if (align === "end") {
      left = triggerRect.right - this.content.offsetWidth
    } else if (align === "center") {
      left =
        triggerRect.left +
        triggerRect.width / 2 -
        this.content.offsetWidth / 2
    }

    const viewportWidth = window.innerWidth
    if (left + this.content.offsetWidth > viewportWidth - 8) {
      left = viewportWidth - this.content.offsetWidth - 8
    }
    if (left < 8) left = 8

    this.content.style.position = "fixed"
    this.content.style.top = `${top}px`
    this.content.style.left = `${left}px`
    this.content.style.margin = "0"

    const width = this.content.dataset.width
    if (width === "default" || !width) {
      this.content.style.minWidth = `${triggerRect.width}px`
    }
  },

  handleFilter() {
    if (!this.input) return

    const query = this.input.value.toLowerCase().trim()
    let visibleCount = 0

    this.getOptions().forEach((option) => {
      const text = option.textContent.toLowerCase()
      const matches = query === "" || text.includes(query)
      option.hidden = !matches
      if (matches) visibleCount++
    })

    if (this.emptyEl) {
      this.emptyEl.hidden = visibleCount > 0
    }
  },

  resetFilter() {
    this.getOptions().forEach((option) => {
      option.hidden = false
    })
    if (this.emptyEl) {
      this.emptyEl.hidden = true
    }
  },

  handleOptionClick(event) {
    const option = event.target.closest("[data-combobox-part='option']")
    if (!option) return
    if (option.getAttribute("aria-disabled") === "true") return

    this.selectOption(option)
  },

  selectOption(option) {
    const value = option.dataset.value
    const label = this.getOptionLabel(option)

    if (this.value === value) {
      this.value = ""
      this.updateLabel(this.placeholder)
    } else {
      this.value = value
      this.updateLabel(label)
    }

    this.updateSelection()
    this.updateTriggerState()

    if (this.content) {
      this.content.hidePopover()
    }

    this.el.dispatchEvent(
      new CustomEvent("combobox:change", {
        bubbles: true,
        detail: { value: this.value, label: this.value ? label : null },
      })
    )
  },

  getOptionLabel(option) {
    const clone = option.cloneNode(true)
    const check = clone.querySelector("[data-combobox-part='check']")
    if (check) check.remove()
    return clone.textContent.trim()
  },

  updateSelection() {
    this.getOptions().forEach((option) => {
      const isSelected = option.dataset.value === this.value
      option.dataset.selected = isSelected
      option.setAttribute("aria-selected", isSelected)

      const check = option.querySelector("[data-combobox-part='check']")
      if (check) {
        check.classList.toggle("invisible", !isSelected)
      }
    })
  },

  updateSelectionFromValue() {
    const selectedOption = this.getOptions().find(
      (opt) => opt.dataset.value === this.value
    )
    if (selectedOption) {
      const label = this.getOptionLabel(selectedOption)
      this.updateLabel(label)
      this.updateSelection()
    }
  },

  updateLabel(text) {
    if (this.labelEl) {
      this.labelEl.textContent = text || this.placeholder
    }
  },

  updateTriggerState() {
    if (this.trigger) {
      this.trigger.dataset.hasValue = this.value !== ""
    }
  },

  handleContentKeydown(event) {
    switch (event.key) {
      case "ArrowDown":
        event.preventDefault()
        this.focusNextOption()
        break
      case "ArrowUp":
        event.preventDefault()
        this.focusPreviousOption()
        break
      case "Enter":
        event.preventDefault()
        this.selectFocusedOption()
        break
      case "Home":
        event.preventDefault()
        this.focusFirstOption()
        break
      case "End":
        event.preventDefault()
        this.focusLastOption()
        break
      case "Escape":
        event.preventDefault()
        if (this.content) this.content.hidePopover()
        break
    }
  },

  getOptions() {
    return Array.from(
      this.el.querySelectorAll(
        '[data-combobox-part="option"]:not([aria-disabled="true"])'
      )
    )
  },

  get visibleOptions() {
    return this.getOptions().filter((opt) => !opt.hidden)
  },

  focusFirstOption() {
    const options = this.visibleOptions
    if (options.length > 0) options[0].focus()
  },

  focusLastOption() {
    const options = this.visibleOptions
    if (options.length > 0) options[options.length - 1].focus()
  },

  focusNextOption() {
    const options = this.visibleOptions
    if (options.length === 0) return
    const idx = options.indexOf(document.activeElement)
    const next = idx < options.length - 1 ? idx + 1 : 0
    options[next].focus()
  },

  focusPreviousOption() {
    const options = this.visibleOptions
    if (options.length === 0) return
    const idx = options.indexOf(document.activeElement)
    const prev = idx > 0 ? idx - 1 : options.length - 1
    options[prev].focus()
  },

  selectFocusedOption() {
    const focused = document.activeElement
    const options = this.getOptions()
    if (options.includes(focused)) {
      this.selectOption(focused)
    }
  },
}
