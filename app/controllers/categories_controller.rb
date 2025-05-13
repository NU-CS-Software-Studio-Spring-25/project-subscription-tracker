class CategoriesController < ApplicationController
  def index
    @categories = Category.alphabetical
    @monthly_totals = Category
      .joins(:subscriptions)
      .where(subscriptions: { billing_cycle: "Monthly" })
      .group(:name)
      .sum("subscriptions.price")
    @yearly_totals  = Category
      .joins(:subscriptions)
      .where(subscriptions: { billing_cycle: "Yearly" })
      .group(:name)
      .sum("subscriptions.price")
  end
end
