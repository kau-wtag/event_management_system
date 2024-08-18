RSpec.describe User, type: :model do
  describe 'validations' do
    subject { build(:user) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_length_of(:password).is_at_least(6) }
    it { is_expected.to have_secure_password }
    it { is_expected.to allow_value('user@foo.com').for(:email) }
    it { is_expected.not_to allow_value('user@foo,com').for(:email) }
    it { is_expected.not_to allow_value('user_at_foo.org').for(:email) }
    it { is_expected.not_to allow_value('example.user@foo.').for(:email) }
  end
end
