class MakeUserIdNotNullOnSubscriptions < ActiveRecord::Migration[7.0]
  def change
    change_column_null :subscriptions, :user_id, false
  end
end
