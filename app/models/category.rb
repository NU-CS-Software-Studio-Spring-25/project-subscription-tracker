class Category < ApplicationRecord
	has_many :subscriptions, dependent: :nullify
	validates :name, presence: true, uniqueness: true
	scope :alphabetical, -> { order(:name) }
end
