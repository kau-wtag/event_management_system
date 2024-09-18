class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :event

  validates :rating, presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }
  validates :review, length: { maximum: 500 }
end
