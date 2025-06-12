# app/controllers/subscriptions_controller.rb
class SubscriptionsController < ApplicationController
  include ActionView::Helpers::NumberHelper
  before_action :authenticate_user!
  before_action :set_subscription, only: %i[update destroy price_analysis quick_analysis]
  before_action :load_categories,    only: %i[index create update]

  def index
    #Find subscriptions with billing date within set date
    all_subs = current_user.subscriptions.includes(:category).order(created_at: :desc)
    upcoming = all_subs.select do |sub|
      sub.next_payment_date.between?(
        Date.today,
        Date.today + sub.notification_days_before.days)
    end
  
    if upcoming.any?
      names = upcoming.map(&:name).to_sentence(two_words_connector: " and ")
      flash.now[:alert] = "Heads up! Your #{names} subscription#{'s' if upcoming.size > 1} #{upcoming.size > 1 ? 'are' : 'is'} due soon."      
    end

    load_paginated_subscriptions
    @subscription = Subscription.new # Add this for the modal form
  end

  def create
    @subscription = current_user.subscriptions.build(subscription_params)
    
    Rails.logger.info "Create request format: #{request.format}"
    
    if @subscription.save
      check_budget_after_subscription(@subscription)
      respond_to do |format|
        format.html { redirect_to subscriptions_path, notice: 'Subscription was successfully created.' }
        format.json { render json: { success: true, subscription: @subscription }, status: :created }
      end
    else
      # When validation fails, reload the index page with errors
      load_paginated_subscriptions
      respond_to do |format|
        format.html { 
          flash.now[:alert] = 'Please fix the errors below.'
          render :index, status: :unprocessable_entity 
        }
        format.json { render json: { errors: @subscription.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def update
    Rails.logger.info "Update request format: #{request.format}"
    
    if @subscription.update(subscription_params)
      check_budget_after_subscription(@subscription)
      respond_to do |format|
        format.html { redirect_to subscriptions_path, notice: 'Subscription was successfully updated.' }
        format.json { render json: { success: true, subscription: @subscription }, status: :ok }
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.json { render json: { errors: @subscription.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @subscription.destroy
    redirect_to subscriptions_path, notice: 'Subscription deleted successfully!'
  end
  def summary
    @total_count   = current_user.subscriptions.count
    @total_price   = current_user.subscriptions.sum(:price)
    @monthly_count = current_user.subscriptions.where(billing_cycle: "Monthly").count
    @yearly_count  = current_user.subscriptions.where(billing_cycle: "Yearly").count
    @next_payment  = current_user.subscriptions.order(:next_payment_date).first&.next_payment_date
    @due_7_days   = current_user.subscriptions
                       .where(next_payment_date: Date.today..7.days.from_now)
                       .sum(:price)
    # in summary action
    @monthly_spend = current_user.subscriptions.where(billing_cycle: "Monthly").sum(:price)
    @yearly_spend  = current_user.subscriptions.where(billing_cycle: "Yearly").sum(:price)
    range = Date.today - 59.days..Date.today
    @payments_by_day = current_user.subscriptions
      .where(next_payment_date: range)
      .group(:next_payment_date)      .count

  end
  
  def price_analysis
    @analysis = MarketAnalysisService.new(@subscription).analyze
  end

  def quick_analysis
    @analysis = MarketAnalysisService.new(@subscription).analyze
    render partial: 'quick_analysis', locals: { analysis: @analysis }
  end

  private

  def set_subscription
    @subscription = current_user.subscriptions.find(params[:id])
  end
  def load_paginated_subscriptions
    # The Pagy initializer (config/initializers/pagy.rb) now correctly sets
    # DEFAULT[:items], DEFAULT[:limit], and disables items_param and items_extra.
    # Explicitly setting items: 10 here is for clarity for this specific action,
    # reinforcing the desired items count.
    @pagy, @subscriptions = pagy(current_user.subscriptions.includes(:category).order(created_at: :desc), items: 10)
  end

  def load_categories
    @categories = Category.alphabetical
  end

  def subscription_params
    params
      .require(:subscription)
      .permit(
        :name,
        :price,
        :billing_cycle,
        :next_payment_date,
        :notes,
        :category_id,      # ← allow category assignment
        :notification_days_before,
      )
  end

  def check_budget_after_subscription(subscription)
    return unless subscription.category&.budgets&.exists?

    category = subscription.category
    budget = category.budgets.find_by(user: current_user)
    return unless budget

    # Calculate total spending for this category
    total_spent = category.subscriptions.where(user: current_user).sum(:price)
    
    if total_spent > budget.amount
      flash[:warning] = "⚠️ You're now over budget in #{category.name} category! Spent: #{number_to_currency(total_spent)}, Budget: #{number_to_currency(budget.amount)}"
    end
  end
end
