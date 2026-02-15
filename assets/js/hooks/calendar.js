/**
 * MaquinaCalendar Hook
 *
 * Handles calendar interactions:
 * - Date selection (single & range)
 * - Month navigation
 * - Keyboard navigation
 * - Day state management
 */
export const MaquinaCalendar = {
  mounted() {
    this.mode = this.el.dataset.calendarMode || "single"
    this.month = parseInt(this.el.dataset.calendarMonth, 10)
    this.year = parseInt(this.el.dataset.calendarYear, 10)
    this.selected = this.el.dataset.calendarSelected || ""
    this.selectedEnd = this.el.dataset.calendarSelectedEnd || ""
    this.minDate = this.el.dataset.calendarMinDate || ""
    this.maxDate = this.el.dataset.calendarMaxDate || ""
    this.weekStartsOn = this.el.dataset.calendarWeekStartsOn || "sunday"

    this.handleDayClick = this.handleDayClick.bind(this)
    this.handleKeydown = this.handleKeydown.bind(this)
    this.handleNavClick = this.handleNavClick.bind(this)

    this.el.addEventListener("click", this.handleDayClick)
    this.el.addEventListener("keydown", this.handleKeydown)
    this.el.addEventListener("click", this.handleNavClick)

    this.updateDayStates()
  },

  destroyed() {
    this.el.removeEventListener("click", this.handleDayClick)
    this.el.removeEventListener("keydown", this.handleKeydown)
    this.el.removeEventListener("click", this.handleNavClick)
  },

  handleNavClick(event) {
    const btn = event.target.closest("[data-calendar-action]")
    if (!btn) return

    event.preventDefault()
    const action = btn.dataset.calendarAction

    if (action === "prev") this.previousMonth()
    else if (action === "next") this.nextMonth()
  },

  previousMonth() {
    let newMonth = this.month - 1
    let newYear = this.year

    if (newMonth < 1) {
      newMonth = 12
      newYear -= 1
    }

    this.navigateToMonth(newMonth, newYear)
  },

  nextMonth() {
    let newMonth = this.month + 1
    let newYear = this.year

    if (newMonth > 12) {
      newMonth = 1
      newYear += 1
    }

    this.navigateToMonth(newMonth, newYear)
  },

  navigateToMonth(month, year) {
    this.month = month
    this.year = year
    this.rebuildCalendar()

    this.el.dispatchEvent(
      new CustomEvent("calendar:navigate", {
        bubbles: true,
        detail: {
          month,
          year,
          selected: this.selected,
          selectedEnd: this.selectedEnd,
        },
      })
    )
  },

  rebuildCalendar() {
    const grid = this.el.querySelector("[data-calendar-part='grid']")
    const caption = this.el.querySelector("[data-calendar-part='caption']")
    if (!grid) return

    const year = this.year
    const month = this.month
    const firstOfMonth = new Date(year, month - 1, 1)
    const lastOfMonth = new Date(year, month, 0)

    if (caption) {
      const locale = document.documentElement.lang || undefined
      caption.textContent = firstOfMonth.toLocaleDateString(locale, {
        month: "long",
        year: "numeric",
      })
    }

    const weekStart = this.weekStartsOn === "monday" ? 1 : 0
    const daysBefore = (firstOfMonth.getDay() - weekStart + 7) % 7
    const calendarStart = new Date(firstOfMonth)
    calendarStart.setDate(calendarStart.getDate() - daysBefore)

    const totalDays = daysBefore + lastOfMonth.getDate()
    const weeksNeeded = Math.min(Math.ceil(totalDays / 7), 6)

    const weeks = []
    const currentDate = new Date(calendarStart)
    for (let w = 0; w < weeksNeeded; w++) {
      const week = []
      for (let d = 0; d < 7; d++) {
        week.push(new Date(currentDate))
        currentDate.setDate(currentDate.getDate() + 1)
      }
      weeks.push(week)
    }

    const minDate = this.minDate ? new Date(this.minDate) : null
    const maxDate = this.maxDate ? new Date(this.maxDate) : null

    grid.innerHTML = weeks
      .map((week) =>
        this.buildWeekHTML(week, month, minDate, maxDate)
      )
      .join("")

    this.updateDayStates()
  },

  buildWeekHTML(days, displayMonth, minDate, maxDate) {
    const daysHTML = days
      .map((day) => {
        const dateStr = this.formatDate(day)
        const isOutside = day.getMonth() + 1 !== displayMonth
        const isToday = this.isSameDate(day, new Date())
        const isDisabled =
          (minDate && day < minDate) || (maxDate && day > maxDate)

        const attrs = [
          'type="button"',
          'data-calendar-part="day"',
          `data-date="${dateStr}"`,
          `tabindex="${isToday ? "0" : "-1"}"`,
        ]

        if (isOutside) attrs.push('data-outside="true"')
        if (isToday) attrs.push('data-today="true" aria-current="date"')
        if (isDisabled) attrs.push("disabled")

        return `<button ${attrs.join(" ")}>${day.getDate()}</button>`
      })
      .join("")

    return `<div data-calendar-part="week" role="row">${daysHTML}</div>`
  },

  handleDayClick(event) {
    const button = event.target.closest("[data-calendar-part='day']")
    if (!button || button.disabled) return

    event.preventDefault()
    const dateStr = button.dataset.date

    if (this.mode === "range") {
      this.handleRangeSelection(dateStr)
    } else {
      this.handleSingleSelection(dateStr)
    }
  },

  handleSingleSelection(dateStr) {
    if (this.selected === dateStr) {
      this.selected = ""
    } else {
      this.selected = dateStr
    }

    this.updateDayStates()
    this.updateInputs()
    this.dispatchChange()
  },

  handleRangeSelection(dateStr) {
    if (!this.selected || (this.selected && this.selectedEnd)) {
      this.selected = dateStr
      this.selectedEnd = ""
    } else {
      if (dateStr < this.selected) {
        this.selectedEnd = this.selected
        this.selected = dateStr
      } else if (dateStr === this.selected) {
        this.selected = ""
        this.selectedEnd = ""
      } else {
        this.selectedEnd = dateStr
      }
    }

    this.updateDayStates()
    this.updateInputs()
    this.dispatchChange()
  },

  handleKeydown(event) {
    const button = event.target.closest("[data-calendar-part='day']")
    if (!button) return

    const currentDate = new Date(button.dataset.date + "T00:00:00")
    let targetDate = null

    switch (event.key) {
      case "ArrowRight":
        event.preventDefault()
        targetDate = new Date(currentDate)
        targetDate.setDate(targetDate.getDate() + 1)
        break
      case "ArrowLeft":
        event.preventDefault()
        targetDate = new Date(currentDate)
        targetDate.setDate(targetDate.getDate() - 1)
        break
      case "ArrowDown":
        event.preventDefault()
        targetDate = new Date(currentDate)
        targetDate.setDate(targetDate.getDate() + 7)
        break
      case "ArrowUp":
        event.preventDefault()
        targetDate = new Date(currentDate)
        targetDate.setDate(targetDate.getDate() - 7)
        break
      case "Home":
        event.preventDefault()
        targetDate = new Date(
          currentDate.getFullYear(),
          currentDate.getMonth(),
          1
        )
        break
      case "End":
        event.preventDefault()
        targetDate = new Date(
          currentDate.getFullYear(),
          currentDate.getMonth() + 1,
          0
        )
        break
      default:
        return
    }

    if (targetDate) {
      this.focusDate(targetDate)
    }
  },

  focusDate(date) {
    const dateStr = this.formatDate(date)
    const days = this.el.querySelectorAll("[data-calendar-part='day']")
    const targetButton = Array.from(days).find(
      (btn) => btn.dataset.date === dateStr
    )

    if (targetButton && !targetButton.disabled) {
      targetButton.focus()
    } else {
      this.navigateToMonth(date.getMonth() + 1, date.getFullYear())
      requestAnimationFrame(() => {
        const newDays = this.el.querySelectorAll("[data-calendar-part='day']")
        const newButton = Array.from(newDays).find(
          (btn) => btn.dataset.date === dateStr
        )
        if (newButton && !newButton.disabled) {
          newButton.focus()
        }
      })
    }
  },

  updateDayStates() {
    const days = this.el.querySelectorAll("[data-calendar-part='day']")

    days.forEach((button) => {
      const dateStr = button.dataset.date
      let state = null

      if (this.mode === "range" && this.selected && this.selectedEnd) {
        if (dateStr === this.selected) {
          state = "range-start"
        } else if (dateStr === this.selectedEnd) {
          state = "range-end"
        } else if (dateStr > this.selected && dateStr < this.selectedEnd) {
          state = "range-middle"
        }
      } else if (
        this.mode === "range" &&
        this.selected &&
        !this.selectedEnd
      ) {
        if (dateStr === this.selected) {
          state = "range-start"
        }
      } else if (this.selected && dateStr === this.selected) {
        state = "selected"
      }

      if (state) {
        button.dataset.state = state
        button.setAttribute("aria-selected", "true")
      } else {
        delete button.dataset.state
        button.removeAttribute("aria-selected")
      }
    })
  },

  updateInputs() {
    const input = this.el.querySelector("[data-calendar-part='input']")
    const inputEnd = this.el.querySelector("[data-calendar-part='input-end']")

    if (input) input.value = this.selected || ""
    if (inputEnd) inputEnd.value = this.selectedEnd || ""
  },

  dispatchChange() {
    this.el.dispatchEvent(
      new CustomEvent("calendar:change", {
        bubbles: true,
        detail: {
          mode: this.mode,
          selected: this.selected || null,
          selectedEnd: this.selectedEnd || null,
        },
      })
    )
  },

  formatDate(date) {
    const year = date.getFullYear()
    const month = String(date.getMonth() + 1).padStart(2, "0")
    const day = String(date.getDate()).padStart(2, "0")
    return `${year}-${month}-${day}`
  },

  isSameDate(date1, date2) {
    return (
      date1.getFullYear() === date2.getFullYear() &&
      date1.getMonth() === date2.getMonth() &&
      date1.getDate() === date2.getDate()
    )
  },

  clear() {
    this.selected = ""
    this.selectedEnd = ""
    this.updateDayStates()
    this.updateInputs()
    this.dispatchChange()
  },
}
