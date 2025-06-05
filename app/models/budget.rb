class Budget < ApplicationRecord
  belongs_to :category
  belongs_to :user
  
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :target_period, inclusion: { in: %w[monthly yearly] }
  validates :category_id, uniqueness: { scope: [:user_id, :target_period] }
end