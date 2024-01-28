require 'rails_helper'

RSpec.describe DailyRecordsController, type: :controller do
  describe 'GET #index' do
    before { FactoryBot.create_list(:daily_record, 10) }

    it 'fetches all daily records' do
      get :index
      expect(response).to have_http_status(:ok)
      expect(assigns(:daily_records).count).to eq(DailyRecord.count)
    end
  end
end
