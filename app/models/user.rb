class User < ApplicationRecord
  has_secure_password
  has_many :events, foreign_key: 'organizer_id', dependent: :destroy
  has_one_attached :avatar
  has_many :registrations
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :ratings, dependent: :destroy

  # Role enum to define user roles
  enum role: { user: 'user', organizer: 'organizer', admin: 'admin' }

  before_create :generate_verification_token
  after_create :send_verification_email

  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?

  def generate_password_reset_token!
    self.reset_password_token = SecureRandom.hex(10)
    self.reset_password_sent_at = Time.zone.now
    save!(validate: false)
  end

  def password_reset_token_valid?
    reset_password_sent_at > 2.hours.ago
  end

  def reset_password!(password)
    self.reset_password_token = nil
    self.password = password
    save!
  end

  private

  def generate_verification_token
    self.verification_token = SecureRandom.hex(10)
  end

  def send_verification_email
    UserMailer.email_verification(self).deliver_now
  end

  def password_required?
    new_record? || password.present?
  end
end
