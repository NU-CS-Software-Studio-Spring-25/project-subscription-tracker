# app/controllers/subscriptions_controller.rb
class SubscriptionsController < ApplicationController
    def index
      @subscriptions = Subscription.all
    end
  
    def create
      @subscription = Subscription.new(subscription_params)
      if @subscription.save
        redirect_to subscriptions_path, notice: 'Subscription added successfully!'
      else
        redirect_to subscriptions_path, alert: 'Error adding subscription.'
      end
    end
  
    def update
      @subscription = Subscription.find(params[:id])
      if @subscription.update(subscription_params)
        redirect_to subscriptions_path, notice: 'Subscription updated successfully!'
      else
        redirect_to subscriptions_path, alert: 'Error updating subscription.'
      end
    end
  
    def destroy
      @subscription = Subscription.find(params[:id])
      @subscription.destroy
      redirect_to subscriptions_path, notice: 'Subscription deleted successfully!'
    end

    def summary
      @total_count     = Subscription.count
      @total_price     = Subscription.sum(:price)
      @monthly_count   = Subscription.where(billing_cycle: "Monthly").count
      @yearly_count    = Subscription.where(billing_cycle: "Yearly").count
      @next_payment    = Subscription.order(:next_payment_date).first&.next_payment_date
      @due_30_days     = Subscription
                           .where(next_payment_date: Date.today..30.days.from_now)
                           .sum(:price)
    end    
  
    private
  
    def subscription_params
      params.require(:subscription).permit(:name, :price, :billing_cycle, :next_payment_date, :notes)
    end
  end