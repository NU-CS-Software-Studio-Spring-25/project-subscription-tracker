// app/javascript/controllers/price_analysis_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content"]
  static values = { subscriptionId: Number }
  connect() {
    console.log("Price Analysis controller connected")
    // Add event listener for modal show event
    this.element.addEventListener('shown.bs.modal', () => {
      this.loadAnalysis()
    })
  }

  loadAnalysis() {
    const subscriptionId = this.subscriptionIdValue
    const contentTarget = this.contentTarget
    
    console.log("Loading analysis for subscription:", subscriptionId)
    
    // Show loading state
    contentTarget.innerHTML = `
      <div class="text-center p-4">
        <div class="spinner-border text-info" role="status">
          <span class="visually-hidden">Loading price analysis...</span>
        </div>
        <p class="mt-2 text-muted">Analyzing market data...</p>
      </div>
    `
    
    // Fetch analysis data
    fetch(`/subscriptions/${subscriptionId}/quick_analysis`, {
      method: 'GET',
      headers: {
        'Accept': 'text/html',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      }
    })
    .then(response => {
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`)
      }
      return response.text()
    })
    .then(html => {
      contentTarget.innerHTML = html
    })
    .catch(error => {
      console.error('Error loading price analysis:', error)
      contentTarget.innerHTML = `
        <div class="alert alert-danger">
          <i class="bi bi-exclamation-triangle"></i>
          <strong>Error loading analysis</strong><br>
          Please try again later or view the detailed analysis.
        </div>
      `
    })
  }
}
