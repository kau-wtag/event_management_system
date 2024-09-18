class Follow < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :organizer, class_name: 'User'

  validates :follower_id, uniqueness: { scope: :organizer_id }
end
