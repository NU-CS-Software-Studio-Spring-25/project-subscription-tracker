class AddNotificationWindowToSubscriptions < ActiveRecord::Migration[8.0]
  def change
    add_column :subscriptions, :notification_days_before, :integer, null: false, default: 7
  end
end
