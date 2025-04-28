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
  
    private
  
    def subscription_params
      params.require(:subscription).permit(:name, :price, :billing_cycle, :next_payment_date, :notes)
    end
  end