import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    categories: Array,
    subscription: Object,
    isEdit: Boolean
  }

  connect() {
    console.log('SubscriptionForm controller connected')
    console.log('Categories:', this.categoriesValue)
    console.log('Subscription:', this.subscriptionValue)
    console.log('IsEdit:', this.isEditValue)
    this.renderForm()
  }

  getCurrentDate() {
    return new Date().toISOString().split('T')[0]
  }

  getMaxDate() {
    const maxDate = new Date()
    maxDate.setFullYear(maxDate.getFullYear() + 1)
    return maxDate.toISOString().split('T')[0]
  }

  renderForm() {
    const formData = this.isEditValue ? this.subscriptionValue : {
      name: '',
      category_id: '',
      price: '',
      billing_cycle: 'Monthly',
      next_payment_date: this.getCurrentDate(),
      notification_days_before: 7
    }

    console.log('Rendering form with data:', formData)
    this.element.innerHTML = this.createFormHTML(formData)
    this.attachEventListeners()
  }

  createFormHTML(formData) {
    const options = this.categoriesValue.map(cat => 
      `<option value="${cat.id}" ${formData.category_id == cat.id ? 'selected' : ''}>${cat.name}</option>`
    ).join('')

    return `
      <form class="subscription-form">
        <div class="modal-body">
          <div class="mb-3">
            <label class="form-label">Service Name *</label>
            <input type="text" class="form-control" name="name" value="${formData.name}" required>
            <div class="invalid-feedback"></div>
          </div>
          <div class="mb-3">
            <label class="form-label">Category *</label>
            <select class="form-select" name="category_id" required>
              <option value="">Select a category</option>
              ${options}
            </select>
            <div class="invalid-feedback"></div>
          </div>
          <div class="mb-3">
            <label class="form-label">Amount ($) *</label>
            <input type="number" step="0.01" class="form-control" name="price" value="${formData.price}" required>
            <div class="invalid-feedback"></div>
          </div>
          <div class="mb-3">
            <label class="form-label">Billing Cycle *</label>
            <select class="form-select" name="billing_cycle" required>
              <option value="Monthly" ${formData.billing_cycle === 'Monthly' ? 'selected' : ''}>Monthly</option>
              <option value="Yearly" ${formData.billing_cycle === 'Yearly' ? 'selected' : ''}>Yearly</option>
            </select>
          </div>
          <div class="mb-3">
            <label class="form-label">Next Payment Date *</label>
            <input type="date" class="form-control" name="next_payment_date" 
                   value="${formData.next_payment_date}" min="${this.getCurrentDate()}" 
                   max="${this.getMaxDate()}" required>
            <div class="invalid-feedback"></div>
          </div>
          <div class="mb-3">
            <label class="form-label">Notification Days Before</label>
            <input type="number" class="form-control" name="notification_days_before" 
                   value="${formData.notification_days_before}" min="0" max="365">
            <div class="invalid-feedback"></div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary">${this.isEditValue ? 'Save Changes' : 'Add Subscription'}</button>
        </div>
      </form>`
  }

  attachEventListeners() {
    const form = this.element.querySelector('.subscription-form')
    form.addEventListener('submit', (e) => this.handleSubmit(e))
    
    form.querySelectorAll('input, select').forEach(field => {
      field.addEventListener('input', () => this.clearError(field))
    })
  }

  validateForm(form) {
    let isValid = true
    const formData = new FormData(form)
    
    // Name validation
    const name = formData.get('name').trim()
    if (!name || name.length < 2) {
      this.showError(form.querySelector('[name="name"]'), 'Name must be at least 2 characters')
      isValid = false
    }
    
    // Category validation
    if (!formData.get('category_id')) {
      this.showError(form.querySelector('[name="category_id"]'), 'Please select a category')
      isValid = false
    }
    
    // Price validation
    const price = parseFloat(formData.get('price'))
    if (!price || price <= 0) {
      this.showError(form.querySelector('[name="price"]'), 'Price must be greater than 0')
      isValid = false
    }
    
    // Date validation
    const date = new Date(formData.get('next_payment_date'))
    const today = new Date()
    const maxDate = new Date()
    maxDate.setFullYear(maxDate.getFullYear() + 1)
    
    if (date < today) {
      this.showError(form.querySelector('[name="next_payment_date"]'), 'Date cannot be in the past')
      isValid = false
    } else if (date > maxDate) {
      this.showError(form.querySelector('[name="next_payment_date"]'), 'Date cannot be more than 1 year from now')
      isValid = false
    }
    
    return isValid
  }

  showError(field, message) {
    field.classList.add('is-invalid')
    const feedback = field.parentNode.querySelector('.invalid-feedback')
    if (feedback) feedback.textContent = message
  }

  clearError(field) {
    field.classList.remove('is-invalid')
    const feedback = field.parentNode.querySelector('.invalid-feedback')
    if (feedback) feedback.textContent = ''
  }

  async handleSubmit(e) {
    e.preventDefault()
    const form = e.target
    
    console.log('Form submitted')
    console.log('Is edit:', this.isEditValue)
    
    if (!this.validateForm(form)) return
    
    const submitBtn = form.querySelector('button[type="submit"]')
    const originalText = submitBtn.textContent
    submitBtn.disabled = true
    submitBtn.textContent = this.isEditValue ? 'Updating...' : 'Adding...'
    
    try {
      const formData = new FormData(form)
      const data = Object.fromEntries(formData)
      const url = this.isEditValue ? `/subscriptions/${this.subscriptionValue.id}` : '/subscriptions'
      const method = this.isEditValue ? 'PATCH' : 'POST'
      
      console.log('Sending request:', { method, url, data })
      
      const response = await fetch(url, {
        method: method,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
        },
        body: JSON.stringify({ subscription: data })
      })

      console.log('Response status:', response.status)
      console.log('Response headers:', [...response.headers.entries()])

      if (response.ok) {
        const responseData = await response.json()
        console.log('Success response:', responseData)
        this.showSuccess(this.isEditValue ? 'Updated successfully!' : 'Added successfully!')
        setTimeout(() => window.location.reload(), 1000)
      } else {
        console.log('Error response status:', response.status)
        const responseText = await response.text()
        console.log('Error response text:', responseText)
        
        try {
          const errorData = JSON.parse(responseText)
          if (errorData.errors && errorData.errors.length > 0) {
            alert('Validation errors: ' + errorData.errors.join(', '))
          } else {
            alert('Server error: ' + (errorData.message || 'Unknown error'))
          }
        } catch (parseError) {
          console.error('Failed to parse error response:', parseError)
          alert('Server returned an error. Response: ' + responseText.substring(0, 100))
        }
      }
    } catch (error) {
      console.error('Network error:', error)
      alert('Network error occurred. Please check your connection and try again.')
    } finally {
      submitBtn.disabled = false
      submitBtn.textContent = originalText
    }
  }

  showSuccess(message) {
    const alert = document.createElement('div')
    alert.className = 'alert alert-success position-fixed top-0 start-50 translate-middle-x mt-3'
    alert.style.zIndex = '1060'
    alert.textContent = message
    document.body.appendChild(alert)
    setTimeout(() => alert.remove(), 3000)
  }
} 