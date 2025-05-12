class Subscription < ApplicationRecord
    belongs_to :category, optional: true

    validates :name, presence: true
    validates :price, presence: true
    validates :billing_cycle, presence: true
    validates :next_payment_date, presence: true
  end