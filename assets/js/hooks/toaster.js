/**
 * MaquinaToaster Hook
 *
 * Manages the toast container and provides a global JavaScript API
 * for creating toasts programmatically.
 *
 * Usage:
 *   Toast.success("Message saved!")
 *   Toast.error("Something went wrong", { description: "Please try again" })
 *   Toast.info("New update available", { duration: 10000 })
 *   Toast.dismissAll()
 */
export const MaquinaToaster = {
  mounted() {
    this.maxVisible = 5
    this.setupGlobalApi()
  },

  destroyed() {
    if (window.Toast && window.Toast._hook === this) {
      delete window.Toast
    }
  },

  setupGlobalApi() {
    const hook = this

    window.Toast = {
      _hook: hook,

      show(title, options = {}) {
        return hook.createToast({ title, ...options })
      },
      success(title, options = {}) {
        return hook.createToast({ title, variant: "success", ...options })
      },
      info(title, options = {}) {
        return hook.createToast({ title, variant: "info", ...options })
      },
      warning(title, options = {}) {
        return hook.createToast({ title, variant: "warning", ...options })
      },
      error(title, options = {}) {
        return hook.createToast({ title, variant: "error", ...options })
      },
      dismiss(toastId) {
        hook.dismissToast(toastId)
      },
      dismissAll() {
        hook.dismissAllToasts()
      },
    }
  },

  createToast({
    title = "",
    description = "",
    variant = "default",
    duration = 5000,
    dismissible = true,
  } = {}) {
    const id = `toast-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`

    const titleHtml = title
      ? `<div data-toast-part="title">${this.escapeHtml(title)}</div>`
      : ""
    const descHtml = description
      ? `<div data-toast-part="description">${this.escapeHtml(description)}</div>`
      : ""
    const closeHtml = dismissible
      ? `<button type="button" data-toast-part="close" aria-label="Dismiss notification"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg></button>`
      : ""

    const html = `
      <div id="${id}" phx-hook="MaquinaToast" data-component="toast" data-variant="${variant}" data-duration="${duration}" data-dismissible="${dismissible}" data-state="entering" role="alert">
        <div data-toast-part="content">${titleHtml}${descHtml}</div>
        ${closeHtml}
      </div>
    `.trim()

    this.el.insertAdjacentHTML("beforeend", html)
    this.enforceMaxVisible()

    return id
  },

  escapeHtml(text) {
    const div = document.createElement("div")
    div.textContent = text
    return div.innerHTML
  },

  dismissToast(toastId) {
    const toast = document.getElementById(toastId)
    if (toast) {
      toast.dataset.state = "exiting"
      setTimeout(() => toast.remove(), 150)
    }
  },

  dismissAllToasts() {
    const toasts = this.el.querySelectorAll('[data-component="toast"]')
    toasts.forEach((toast) => {
      toast.dataset.state = "exiting"
      setTimeout(() => toast.remove(), 150)
    })
  },

  enforceMaxVisible() {
    const toasts = this.el.querySelectorAll('[data-component="toast"]')
    const excess = toasts.length - this.maxVisible
    if (excess > 0) {
      for (let i = 0; i < excess; i++) {
        toasts[i].dataset.state = "exiting"
        setTimeout(() => toasts[i].remove(), 150)
      }
    }
  },
}
