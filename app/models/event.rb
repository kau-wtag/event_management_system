class Event < ApplicationRecord
  belongs_to :category, optional: true

  has_many :registrations, dependent: :destroy
  has_many :users, through: :registrations
  has_one_attached :image

  validates :name, presence: true
  validates :description, presence: true, length: { minimum: 10 }
  validates :location, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :capacity, numericality: { only_integer: true, greater_than: 0 }
  validates :category_id, presence: true

  def self.upcoming
    where('starts_at > ?', Time.now).order('starts_at')
  end

  def free?
    price.blank? || price.zero?
  end

  def sold_out?
    (capacity - registrations.size).zero?
  end

end
