/**
 * MaquinaDatePicker Hook
 *
 * Coordinates the trigger button, popover, and calendar.
 * Uses native Popover API for open/close.
 * Listens for calendar:change events to update display.
 */
export const MaquinaDatePicker = {
  mounted() {
    this.mode = this.el.dataset.datePickerMode || "single"
    this.selected = this.el.dataset.datePickerSelected || ""
    this.selectedEnd = this.el.dataset.datePickerSelectedEnd || ""

    this.trigger = this.el.querySelector("[data-date-picker-part='trigger']")
    this.popover = this.el.querySelector("[data-date-picker-part='popover']")
    this.display = this.el.querySelector("[data-date-picker-part='display']")
    this.input = this.el.querySelector("[data-date-picker-part='input']")
    this.inputEnd = this.el.querySelector("[data-date-picker-part='input-end']")

    this.handlePopoverToggle = this.handlePopoverToggle.bind(this)
    this.handleCalendarChange = this.handleCalendarChange.bind(this)

    if (this.popover) {
      this.popover.addEventListener("toggle", this.handlePopoverToggle)
    }

    this.el.addEventListener("calendar:change", this.handleCalendarChange)

    this.updateDisplay()
  },

  destroyed() {
    if (this.popover) {
      this.popover.removeEventListener("toggle", this.handlePopoverToggle)
    }
    this.el.removeEventListener("calendar:change", this.handleCalendarChange)
  },

  handlePopoverToggle(event) {
    const isOpen = event.newState === "open"

    if (this.trigger) {
      this.trigger.setAttribute("aria-expanded", isOpen.toString())
    }

    if (isOpen) {
      requestAnimationFrame(() => {
        const calendar = this.popover.querySelector(
          "[data-component='calendar']"
        )
        if (calendar) {
          const focusable = calendar.querySelector(
            "[data-today], [data-calendar-part='day']"
          )
          if (focusable) focusable.focus()
        }
      })
    }
  },

  handleCalendarChange(event) {
    const { selected, selectedEnd } = event.detail

    this.selected = selected || ""
    this.selectedEnd = selectedEnd || ""

    this.updateInputs()
    this.updateDisplay()

    if (this.mode === "single" && selected) {
      this.closePopover()
    } else if (this.mode === "range" && selected && selectedEnd) {
      this.closePopover()
    }

    this.el.dispatchEvent(
      new CustomEvent("date-picker:change", {
        bubbles: true,
        detail: {
          selected: this.selected || null,
          selectedEnd: this.selectedEnd || null,
        },
      })
    )
  },

  updateInputs() {
    if (this.input) this.input.value = this.selected || ""
    if (this.inputEnd) this.inputEnd.value = this.selectedEnd || ""
  },

  updateDisplay() {
    if (!this.display) return

    let displayText = ""

    if (this.mode === "range") {
      if (this.selected && this.selectedEnd) {
        displayText = `${this.formatDate(this.selected, "short")} - ${this.formatDate(this.selectedEnd, "short")}`
      } else if (this.selected) {
        displayText = `${this.formatDate(this.selected, "short")} - ...`
      } else {
        displayText = "Select date range"
      }
    } else {
      if (this.selected) {
        displayText = this.formatDate(this.selected, "long")
      } else {
        displayText = "Select date"
      }
    }

    this.display.textContent = displayText

    // Toggle placeholder indicator
    const existing = this.trigger
      ? this.trigger.querySelector(
          "[data-date-picker-part='placeholder-indicator']"
        )
      : null
    if (existing) existing.remove()

    if (!this.selected && this.trigger) {
      const indicator = document.createElement("span")
      indicator.setAttribute(
        "data-date-picker-part",
        "placeholder-indicator"
      )
      this.display.after(indicator)
    }
  },

  formatDate(dateStr, format) {
    if (!dateStr) return ""

    try {
      const date = new Date(dateStr + "T00:00:00")
      const options =
        format === "short"
          ? { month: "short", day: "numeric", year: "numeric" }
          : {
              weekday: "long",
              month: "long",
              day: "numeric",
              year: "numeric",
            }

      const locale = document.documentElement.lang || undefined
      return date.toLocaleDateString(locale, options)
    } catch {
      return dateStr
    }
  },

  closePopover() {
    if (this.popover) {
      this.popover.hidePopover()
    }
  },

  clear() {
    this.selected = ""
    this.selectedEnd = ""
    this.updateInputs()
    this.updateDisplay()

    this.el.dispatchEvent(
      new CustomEvent("date-picker:change", {
        bubbles: true,
        detail: { selected: null, selectedEnd: null },
      })
    )
  },
}
