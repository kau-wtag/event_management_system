# spec/controllers/sessions_controller_spec.rb
require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let!(:user) { create(:user) }

  describe "GET #new" do
    it "returns a successful response" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    context "with valid credentials" do
      it "logs in the user and redirects to the user's show page" do
        post :create, params: { email: user.email, password: user.password }
        expect(session[:user_id]).to eq(user.id)
        expect(response).to redirect_to(user_path(user))
        expect(flash[:notice]).to eq("Welcome back, #{user.name}!")
      end
    end

    context "with invalid credentials" do
      it "does not log in the user and re-renders the new template with an alert" do
        post :create, params: { email: user.email, password: "wrongpassword" }
        expect(session[:user_id]).to be_nil
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash.now[:alert]).to eq("Invalid email or password")
      end
    end
  end

  describe "DELETE #destroy" do
    it "logs out the user and redirects to the root URL with a notice" do
      session[:user_id] = user.id
      delete :destroy
      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to(root_url)
      expect(response).to have_http_status(:see_other)
      expect(flash[:notice]).to eq("You've been sign out!")
    end
  end
end
