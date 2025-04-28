class CreateSubscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :subscriptions do |t|
      t.string :name
      t.decimal :price
      t.string :billing_cycle
      t.date :next_payment_date
      t.text :notes

      t.timestamps
    end
  end
end
