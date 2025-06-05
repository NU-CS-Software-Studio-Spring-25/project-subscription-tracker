class UpdateBudgetsUniqueConstraint < ActiveRecord::Migration[7.0]
  def up
    # Remove the old unique index
    remove_index :budgets, [:category_id, :user_id] if index_exists?(:budgets, [:category_id, :user_id])
    
    # Add the new unique index that includes target_period
    add_index :budgets, [:category_id, :user_id, :target_period], unique: true, name: 'index_budgets_on_category_user_period'
  end
  
  def down
    # Remove the new index
    remove_index :budgets, name: 'index_budgets_on_category_user_period' if index_exists?(:budgets, name: 'index_budgets_on_category_user_period')
    
    # Add back the old index
    add_index :budgets, [:category_id, :user_id], unique: true
  end
end