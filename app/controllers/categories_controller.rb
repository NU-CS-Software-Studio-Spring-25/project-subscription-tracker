class CategoriesController < ApplicationController
  def index
    @categories = Category.alphabetical
    monthly = Category
      .joins(:subscriptions)
      .where(subscriptions: { billing_cycle: "monthly" })
      .group(:name)
      .sum("subscriptions.price")
    yearly  = Category
      .joins(:subscriptions)
      .where(subscriptions: { billing_cycle: "yearly" })
      .group(:name)
      .sum("subscriptions.price")

    @monthly_totals = monthly
    @yearly_totals = yearly
  end
end
