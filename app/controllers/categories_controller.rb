# app/controllers/categories_controller.rb
class CategoriesController < ApplicationController
  def index
    @categories = Category.alphabetical

    @monthly_totals = Category
      .joins(:subscriptions)
      .where(subscriptions: { billing_cycle: "Monthly" })
      .group(:name)
      .sum("subscriptions.price")

    @yearly_totals = Category
      .joins(:subscriptions)
      .where(subscriptions: { billing_cycle: "Yearly" })
      .group(:name)
      .sum("subscriptions.price")
  end

  def budgeting
    # Sum all subscriptions per category
    @category_totals = Category
      .left_joins(:subscriptions)
      .group("categories.name")
      .sum("subscriptions.price")

    # Grand total across all categories
    @total_spent = @category_totals.values.sum
  end
end
