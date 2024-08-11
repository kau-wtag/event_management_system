require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let!(:user) { FactoryBot.create(:user) }

  describe 'GET #new' do
    before { get :new }

    it { is_expected.to respond_with(:success) }
    it { is_expected.to render_template(:new) }
  end

  describe 'POST #create' do
    context 'with valid credentials' do
      before { post :create, params: { email: user.email, password: user.password } }

      it { is_expected.to set_session[:user_id].to(user.id) }
      it { is_expected.to redirect_to(user_path(user)) }
      it { is_expected.to set_flash[:notice].to("Welcome back, #{user.name}!") }
    end

    context 'with invalid credentials' do
      before { post :create, params: { email: user.email, password: 'wrongpassword' } }

      it { is_expected.not_to set_session[:user_id] }
      it { is_expected.to render_template(:new) }
      it { is_expected.to set_flash.now[:alert].to('Invalid email or password') }
    end
  end

  describe 'DELETE #destroy' do
    before do
      session[:user_id] = user.id
      delete :destroy
    end

    it { is_expected.to set_session[:user_id].to(nil) }
    it { is_expected.to redirect_to(root_url) }
  end
end
