class Subscription < ActiveRecord::Base
	validates :notification_days_before,
		presence: true,
		numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end