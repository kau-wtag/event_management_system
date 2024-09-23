class Location < ApplicationRecord
  has_one_attached :image

  validates :name, presence: true, uniqueness: true, length: { maximum: 100 }
  validates :rent_cost, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :capacity, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :contact_email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validates :contact_number, format: { with: /\A[\d+\-() ]+\z/ }, allow_blank: true
  validates :google_map_link, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), allow_blank: true }
  validates :full_address, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 1000 }, allow_blank: true
end
