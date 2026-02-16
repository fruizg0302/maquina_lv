/**
 * MaquinaSidebar Hook
 *
 * Manages sidebar state with:
 * - Cookie persistence
 * - Responsive resize behavior
 * - Keyboard shortcut (Cmd/Ctrl+B)
 * - Mobile overlay with scroll lock
 * - LiveView navigation support
 */
export const MaquinaSidebar = {
  mounted() {
    this.defaultOpen = this.el.dataset.sidebarDefaultOpen === "true"
    this.isOpen = this.el.dataset.sidebarOpen === "true"
    this.cookieName = this.el.dataset.sidebarCookieName || "sidebar_state"
    this.shortcut = this.el.dataset.sidebarKeyboardShortcut || "b"
    this._isMobile = null
    this.scrollPosition = 0

    this.sidebar = this.el.querySelector("[data-sidebar-part='root']")
    this.backdrop = this.el.querySelector("[data-sidebar-part='backdrop']")

    this.handleResize = this.debounce(this.checkScreenSize.bind(this), 100)
    this.handleKeydown = this.handleKeydown.bind(this)
    this.handleBackdropClick = this.handleBackdropClick.bind(this)
    this.handleToggleClick = this.handleToggleClick.bind(this)

    window.addEventListener("resize", this.handleResize)
    document.addEventListener("keydown", this.handleKeydown)

    if (this.backdrop) {
      this.backdrop.addEventListener("click", this.handleBackdropClick)
    }

    // Delegate toggle clicks from trigger buttons
    this.el.addEventListener("click", this.handleToggleClick)

    // Read cookie to restore state
    const cookieValue = this.getCookie(this.cookieName)
    if (cookieValue !== null) {
      this.isOpen = cookieValue === "true"
    }

    this.checkScreenSize()
    this.updateStateImmediate()
  },

  updated() {
    this.sidebar = this.el.querySelector("[data-sidebar-part='root']")
    this.backdrop = this.el.querySelector("[data-sidebar-part='backdrop']")

    if (this.sidebar) {
      this.sidebar.classList.remove("sidebar-loading")
    }

    this.updateState()
  },

  destroyed() {
    window.removeEventListener("resize", this.handleResize)
    document.removeEventListener("keydown", this.handleKeydown)

    if (this.backdrop) {
      this.backdrop.removeEventListener("click", this.handleBackdropClick)
    }

    this.el.removeEventListener("click", this.handleToggleClick)
    this.unlockScroll()
  },

  handleToggleClick(event) {
    const trigger = event.target.closest("[data-sidebar-action='toggle']")
    if (trigger) {
      event.preventDefault()
      this.toggle()
    }
  },

  handleKeydown(event) {
    if (
      (event.metaKey || event.ctrlKey) &&
      event.key === this.shortcut
    ) {
      event.preventDefault()
      this.toggle()
    }
  },

  handleBackdropClick() {
    if (this.isMobile() && this.isOpen) {
      this.close()
    }
  },

  toggle() {
    this.isOpen = !this.isOpen
    this.updateState()
    this.persistState()
    this.dispatchStateChange()
  },

  open() {
    this.isOpen = true
    this.updateState()
    this.persistState()
    this.dispatchStateChange()
  },

  close() {
    this.isOpen = false
    this.updateState()
    this.persistState()
    this.dispatchStateChange()
  },

  updateState() {
    if (!this.sidebar) return

    const state = this.isOpen ? "expanded" : "collapsed"
    const isMobile = this.isMobile()

    this.sidebar.dataset.state = state

    const collapsible = this.isOpen
      ? "none"
      : isMobile
        ? "offcanvas"
        : "icon"

    this.sidebar.dataset.collapsible = collapsible

    if (this.backdrop) {
      const backdropState = this.isOpen && isMobile ? "visible" : "hidden"
      this.backdrop.dataset.state = backdropState

      if (backdropState === "visible") {
        this.backdrop.classList.remove("hidden")
      } else {
        setTimeout(() => {
          if (
            this.backdrop &&
            this.backdrop.dataset.state === "hidden"
          ) {
            this.backdrop.classList.add("hidden")
          }
        }, 300)
      }
    }

    if (isMobile) {
      if (this.isOpen) {
        this.lockScroll()
      } else {
        this.unlockScroll()
      }
    }
  },

  updateStateImmediate() {
    this.updateState()
    requestAnimationFrame(() => {
      if (this.sidebar) {
        this.sidebar.classList.remove("sidebar-loading")
      }
    })
  },

  checkScreenSize() {
    const wasMobile = this._isMobile
    this._isMobile = window.innerWidth < 768

    if (wasMobile === null) {
      if (this._isMobile) {
        this.isOpen = false
      }
      return
    }

    if (wasMobile !== this._isMobile) {
      if (wasMobile && !this._isMobile) {
        // Mobile to desktop: restore saved state
        const cookieValue = this.getCookie(this.cookieName)
        this.isOpen =
          cookieValue !== null ? cookieValue === "true" : this.defaultOpen
      } else if (!wasMobile && this._isMobile) {
        // Desktop to mobile: close sidebar
        this.isOpen = false
      }
      this.updateState()
    }
  },

  isMobile() {
    return this._isMobile ?? window.innerWidth < 768
  },

  persistState() {
    if (!this.isMobile()) {
      this.setCookie(this.cookieName, this.isOpen.toString(), 31536000)
    }
  },

  getCookie(name) {
    const value = `; ${document.cookie}`
    const parts = value.split(`; ${name}=`)
    if (parts.length === 2) {
      return parts.pop().split(";").shift()
    }
    return null
  },

  setCookie(name, value, maxAge) {
    document.cookie = `${name}=${value}; path=/; max-age=${maxAge}; SameSite=Lax`
  },

  lockScroll() {
    this.scrollPosition = window.pageYOffset
    document.body.style.overflow = "hidden"
    document.body.style.position = "fixed"
    document.body.style.top = `-${this.scrollPosition}px`
    document.body.style.width = "100%"
  },

  unlockScroll() {
    document.body.style.overflow = ""
    document.body.style.position = ""
    document.body.style.top = ""
    document.body.style.width = ""
    if (this.scrollPosition !== undefined) {
      window.scrollTo(0, this.scrollPosition)
    }
  },

  dispatchStateChange() {
    this.el.dispatchEvent(
      new CustomEvent("sidebar:state-changed", {
        bubbles: true,
        detail: {
          open: this.isOpen,
          mobile: this.isMobile(),
          state: this.isOpen ? "expanded" : "collapsed",
        },
      })
    )
  },

  debounce(func, wait) {
    let timeout
    return function executedFunction(...args) {
      const later = () => {
        clearTimeout(timeout)
        func(...args)
      }
      clearTimeout(timeout)
      timeout = setTimeout(later, wait)
    }
  },
}
