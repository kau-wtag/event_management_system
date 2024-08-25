class User < ApplicationRecord
  has_secure_password
  has_many :registrations
  has_one_attached :avatar

  before_create :generate_verification_token
  after_create :send_verification_email

  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, if: :new_record?

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
end
