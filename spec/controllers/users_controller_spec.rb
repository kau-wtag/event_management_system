RSpec.describe UsersController, type: :controller do
  let!(:user) { FactoryBot.create(:user) }
  let(:another_user) { FactoryBot.create(:user) }

  describe 'GET #index' do
    before { get :index }

    it { is_expected.to respond_with(:success) }
    it { is_expected.to render_template(:index) }

    it 'assigns all users to @users' do
      another_user
      expect(assigns(:users)).to match_array([user, another_user])
    end
  end

  describe 'GET #show' do
    context 'with valid ID' do
      before { get :show, params: { id: user.id } }

      it { is_expected.to respond_with(:success) }
      it { is_expected.to render_template(:show) }
      it 'assigns the requested user to @user' do
        expect(assigns(:user)).to eq(user)
      end
    end

    context 'with invalid ID' do
      before { get :show, params: { id: 0 } }

      it { is_expected.to redirect_to(root_path) }
    end
  end

  describe 'GET #new' do
    before { get :new }

    it { is_expected.to respond_with(:success) }
    it { is_expected.to render_template(:new) }
    it 'assigns a new user to @user' do
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:user_params) { FactoryBot.attributes_for(:user) }

      it 'creates a new user' do
        expect {
          post :create, params: { user: user_params }
        }.to change(User, :count).by(1)
      end

      it 'redirects to the new user' do
        post :create, params: { user: user_params }
        expect(response).to redirect_to(User.last)
        expect(flash[:notice]).to eq('User was successfully created.')
      end
    end

    context 'with invalid attributes' do
      let(:invalid_user_params) { FactoryBot.attributes_for(:user, email: '') }

      it 'does not create a new user' do
        expect { post :create, params: { user: invalid_user_params } }.not_to change(User, :count)
      end

      it 're-renders the new template' do
        post :create, params: { user: invalid_user_params }
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET #edit' do
    context 'with valid ID' do
      before { get :edit, params: { id: user.id } }

      it { is_expected.to respond_with(:success) }
      it { is_expected.to render_template(:edit) }
      it 'assigns the requested user to @user' do
        expect(assigns(:user)).to eq(user)
      end
    end

    context 'with invalid ID' do
      before { get :edit, params: { id: 0 } }

      it { is_expected.to redirect_to(root_path) }
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      let(:new_attributes) { { name: 'Updated Name', email: 'updated@gmail.com', password: 'updatedpass', password_confirmation: 'updatedpass' } }

      it 'updates the user' do
        patch :update, params: { id: user.id, user: new_attributes }
        user.reload
        expect(user.name).to eq('Updated Name')
      end

      it 'redirects to the user' do
        patch :update, params: { id: user.id, user: new_attributes }
        expect(response).to redirect_to(user)
        expect(flash[:notice]).to eq('User was successfully updated.')
      end
    end

    context 'with invalid attributes' do
      let(:invalid_attributes) { { email: '' } }

      it 'does not update the user' do
        patch :update, params: { id: user.id, user: invalid_attributes }
        user.reload
        expect(user.email).not_to eq('')
      end

      it 're-renders the edit template' do
        patch :update, params: { id: user.id, user: invalid_attributes }
        expect(response).to render_template(:edit)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested user' do
      expect {
        delete :destroy, params: { id: user.id }
      }.to change(User, :count).by(-1)
    end

    it 'redirects to the root path' do
      delete :destroy, params: { id: user.id }
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq('User was successfully deleted.')
    end
  end
end
