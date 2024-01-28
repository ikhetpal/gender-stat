require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let!(:user) { FactoryBot.create(:user) }

  describe 'GET #index' do
    before { FactoryBot.create_list(:user, 10) }

    it 'fetches all users' do
      get :index
      expect(response).to have_http_status(:ok)
      expect(assigns(:users).count).to eq(User.count)
    end

    it 'assigns users based on search parameter' do
      get :index, params: { search: user.full_name }
      expect(assigns(:users)).to eq([{
        'full_name' => user.full_name,
        'age' => user.age,
        'gender' => user.gender,
        'created_at' => user.created_at.strftime("%d %B %Y %M:%S %p"),
        'id' => user.id
      }])
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the user with valid id' do
      expect { delete :destroy, params: { id: user.id } }.to change { User.count }.by(-1)
    end

    it 'raises exception when invalid id is passed' do
      expect { delete :destroy, params: { id: 'invalid' } }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
