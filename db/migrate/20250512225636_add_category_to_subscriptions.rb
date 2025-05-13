class AddCategoryToSubscriptions < ActiveRecord::Migration[8.0]
  def change
    add_reference :subscriptions, :category, null: true, foreign_key: true
  end
end
