class CreateBudgets < ActiveRecord::Migration[8.0]
  def change
    create_table :budgets do |t|
      t.references :category, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.string :target_period, default: 'monthly', null: false
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
    
    add_index :budgets, [:category_id, :user_id], unique: true
  end
end