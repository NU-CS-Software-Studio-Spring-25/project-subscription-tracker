import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["navLink"]

  connect() {
    this.setupKeyboardNavigation()
  }

  setupKeyboardNavigation() {
    document.addEventListener('keydown', this.handleKeyPress.bind(this))
  }

  disconnect() {
    document.removeEventListener('keydown', this.handleKeyPress.bind(this))
  }

  handleKeyPress(event) {
    // Alt + number shortcuts for main navigation
    if (event.altKey && !event.ctrlKey && !event.shiftKey) {
      switch (event.key) {
        case '1':
          this.navigateTo('/subscriptions')
          break
        case '2':
          this.navigateTo('/categories')
          break
        case '3':
          this.navigateTo('/categories/budgeting')
          break
        case 'n':
          // Open "Add New Subscription" modal
          const addModal = document.querySelector('#addSubscriptionModal')
          if (addModal) {
            const modal = new bootstrap.Modal(addModal)
            modal.show()
          }
          break
      }
    }

    // Escape key to close modals and dropdowns
    if (event.key === 'Escape') {
      const openModals = document.querySelectorAll('.modal.show')
      const openDropdowns = document.querySelectorAll('.dropdown-menu.show')
      
      openModals.forEach(modal => {
        const modalInstance = bootstrap.Modal.getInstance(modal)
        if (modalInstance) modalInstance.hide()
      })
      
      openDropdowns.forEach(dropdown => {
        const dropdownInstance = bootstrap.Dropdown.getInstance(dropdown)
        if (dropdownInstance) dropdownInstance.hide()
      })
    }

    // Enter key handling for buttons and links
    if (event.key === 'Enter' && document.activeElement.matches('button, a, [role="button"]')) {
      event.preventDefault()
      document.activeElement.click()
    }

    // Space key handling for buttons and links
    if (event.key === ' ' && document.activeElement.matches('button, a, [role="button"]')) {
      event.preventDefault()
      document.activeElement.click()
    }

    // Tab key navigation enhancement
    if (event.key === 'Tab') {
      this.handleTabNavigation(event)
    }

    // Form submission with Ctrl/Cmd + Enter
    if ((event.ctrlKey || event.metaKey) && event.key === 'Enter' && document.activeElement.matches('form')) {
      event.preventDefault()
      document.activeElement.submit()
    }
  }

  navigateTo(path) {
    window.location.href = path
  }

  handleTabNavigation(event) {
    // Get all focusable elements
    const focusableElements = this.element.querySelectorAll(
      'a[href], button:not([disabled]), input:not([disabled]), select:not([disabled]), textarea:not([disabled]), [tabindex]:not([tabindex="-1"])'
    )
    
    const firstFocusableElement = focusableElements[0]
    const lastFocusableElement = focusableElements[focusableElements.length - 1]

    // If shift + tab on first element, focus last element
    if (event.shiftKey && document.activeElement === firstFocusableElement) {
      event.preventDefault()
      lastFocusableElement.focus()
    }
    // If tab on last element, focus first element
    else if (!event.shiftKey && document.activeElement === lastFocusableElement) {
      event.preventDefault()
      firstFocusableElement.focus()
    }
  }
} 