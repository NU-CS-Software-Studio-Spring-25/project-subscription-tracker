# app/controllers/subscriptions_controller.rb
class SubscriptionsController < ApplicationController
  before_action :set_subscription, only: %i[update destroy]
  before_action :load_categories,    only: %i[index create update]

  def index
    #Find subscriptions with billing date within set date
    all_subs = Subscription.includes(:category).order(created_at: :desc)
    upcoming = all_subs.select do |sub|
      sub.next_payment_date.between?(
        Date.today,
        Date.today + sub.notification_days_before.days)
    end
  
    if upcoming.any?
      names = upcoming.map(&:name).to_sentence(two_words_connector: " and ")
      flash.now[:alert] = "Heads up! Your #{names} subscription#{'s' if upcoming.size > 1}
       #{upcoming.size > 1 ? 'are' : 'is'} due soon."      
    end

    load_paginated_subscriptions
  end

  def create
    @subscription = Subscription.new(subscription_params)
    if @subscription.save
      redirect_to subscriptions_path, notice: 'Subscription added successfully!'
    else
      #redirect_to subscriptions_path, alert: 'Error adding subscription.'
      load_paginated_subscriptions
      flash.now[:alert] = 'Error adding subscription.'
      render :index, status: :unprocessable_entity
    end
  end

  def update
    if @subscription.update(subscription_params)
      redirect_to subscriptions_path, notice: 'Subscription updated successfully!'
    else
      redirect_to subscriptions_path, alert: 'Error updating subscription.'
    end
  end

  def destroy
    @subscription.destroy
    redirect_to subscriptions_path, notice: 'Subscription deleted successfully!'
  end

  def summary
    @total_count   = Subscription.count
    @total_price   = Subscription.sum(:price)
    @monthly_count = Subscription.where(billing_cycle: "Monthly").count
    @yearly_count  = Subscription.where(billing_cycle: "Yearly").count
    @next_payment  = Subscription.order(:next_payment_date).first&.next_payment_date
    @due_7_days   = Subscription
                       .where(next_payment_date: Date.today..7.days.from_now)
                       .sum(:price)
    # in summary action
    @monthly_spend = Subscription.where(billing_cycle: "Monthly").sum(:price)
    @yearly_spend  = Subscription.where(billing_cycle: "Yearly").sum(:price)
    range = Date.today - 59.days..Date.today
    @payments_by_day = Subscription
      .where(next_payment_date: range)
      .group(:next_payment_date)
      .count

  end    

  private

  def set_subscription
    @subscription = Subscription.find(params[:id])
  end

  def load_paginated_subscriptions
    @pagy, @subscriptions = pagy(Subscription.includes(:category).order(created_at: :desc), items: 9)
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
end
