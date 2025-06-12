class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0, message: "must be greater than 0" }
  validates :billing_cycle, presence: true, inclusion: { in: %w[Monthly Yearly] }
  validates :next_payment_date, presence: true
  validates :notification_days_before, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true

  scope :due_soon, ->(days = 7) { where(next_payment_date: Date.current..days.days.from_now) }
  scope :monthly, -> { where(billing_cycle: 'Monthly') }
  scope :yearly, -> { where(billing_cycle: 'Yearly') }
end