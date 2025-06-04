
# This file should contain all the record creation needed to seed the database with its default values.
class MakeUserIdNotNullOnSubscriptions < ActiveRecord::Migration[7.0]
  def change

    reversible do |dir|
      dir.up do
        default_user = User.find_by(email: "default@example.com")

        default_user ||= User.first
        # If no default user is found, we raise an error to prevent the migration from running.
        unless default_user
          raise "Cannot run migration: No default user (default@example.com or any User.first) found. " \
                "Please ensure at least one user exists (e.g., by running db:seed) before this migration."
        end
        # If there are any subscriptions with NULL user_id, we update them to the default user's ID.
        # This is necessary to ensure that we can change the column to not allow NULL values.
        puts "Updating subscriptions with NULL user_id to user_id: #{default_user.id}"
        Subscription.where(user_id: nil).update_all(user_id: default_user.id)
      end
    end
    # After ensuring all NULL user_id values are set to a valid user ID,
    # we can safely change the user_id column to not allow NULL values.
    puts "Changing user_id column to not allow NULL values in subscriptions table."
    change_column_null :subscriptions, :user_id, false
  end
end

# ------ Old code ------
# class MakeUserIdNotNullOnSubscriptions < ActiveRecord::Migration[7.0]
#   def change
#     change_column_null :subscriptions, :user_id, false
#   end
# end