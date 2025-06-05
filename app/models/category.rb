class Category < ApplicationRecord
	has_many :subscriptions, dependent: :nullify
	has_many :budgets, dependent: :destroy
	validates :name, presence: true, uniqueness: true
	scope :alphabetical, -> { order(:name) }
end
