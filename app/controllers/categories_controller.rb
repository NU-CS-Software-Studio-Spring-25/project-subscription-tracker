# app/controllers/categories_controller.rb
class CategoriesController < ApplicationController
  include ActionView::Helpers::NumberHelper
  before_action :authenticate_user!

  def index
    # Only get categories that have subscriptions for the current user
    @categories = Category
      .joins(:subscriptions)
      .where(subscriptions: { user: current_user })
      .distinct
      .alphabetical

    @monthly_totals = Category
      .joins(:subscriptions)
      .where(subscriptions: { billing_cycle: "Monthly", user: current_user })
      .group(:name)
      .sum("subscriptions.price")

    @yearly_totals = Category
      .joins(:subscriptions)
      .where(subscriptions: { billing_cycle: "Yearly", user: current_user })
      .group(:name)
      .sum("subscriptions.price")
  end

  def budgeting
    @period = params[:period] || 'monthly'
    billing_cycle = @period == 'yearly' ? 'Yearly' : 'Monthly'
    
    # Get all categories that have either subscriptions or budgets for the current user and period
    @categories_with_data = Category
      .left_joins(:budgets, :subscriptions)
      .where('(budgets.user_id = ? AND budgets.target_period = ?) OR (subscriptions.user_id = ? AND subscriptions.billing_cycle = ?)', 
             current_user.id, @period, current_user.id, billing_cycle)
      .distinct
      .includes(:budgets, :subscriptions)

    # Calculate category-specific totals
    @category_totals = {}
    over_budget_categories = []
    
    @categories_with_data.each do |category|
      budget = category.budgets.find { |b| b.user_id == current_user.id && b.target_period == @period }
      budget_amount = budget&.amount || 0
      
      actual_spent = category.subscriptions
        .where(user: current_user, billing_cycle: billing_cycle)
        .sum(:price)
      
      @category_totals[category.id] = {
        budget: budget_amount,
        spent: actual_spent,
        category: category
      }

      # Check for over-budget categories
      if budget_amount > 0 && actual_spent > budget_amount
        over_budget_categories << category.name
      end
    end

    # Period-specific flash messages for over-budget categories only
    if over_budget_categories.any?
      flash.now[:warning] = "⚠️ You're over #{@period} budget in: #{over_budget_categories.join(', ')}"
    end
  end

  def update_budget
    @category = Category.find(params[:id])
    target_period = params[:target_period] || 'monthly'
    amount = params[:amount].to_f
    
    # Handle empty or zero amounts
    if amount <= 0
      redirect_to budgeting_categories_path(period: target_period), alert: "Budget amount must be greater than 0."
      return
    end
    
    @budget = current_user.budgets.find_or_initialize_by(
      category: @category, 
      target_period: target_period
    )
    
    if @budget.update(amount: amount)
      # Check if this update puts the category over budget
      billing_cycle = target_period == 'yearly' ? 'Yearly' : 'Monthly'
      actual_spent = @category.subscriptions
        .where(user: current_user, billing_cycle: billing_cycle)
        .sum(:price)
      
      if actual_spent > amount
        flash[:warning] = "⚠️ #{@category.name} is over budget! Spending: #{number_to_currency(actual_spent)}, Budget: #{number_to_currency(amount)}"
      else
        flash[:notice] = "#{target_period.capitalize} budget updated successfully!"
      end
      
      redirect_to budgeting_categories_path(period: target_period)
    else
      redirect_to budgeting_categories_path(period: target_period), alert: "Error updating #{target_period} budget: #{@budget.errors.full_messages.join(', ')}"
    end
  end

  private

  def budget_params
    params.require(:budget).permit(:amount, :target_period)
  end
end
