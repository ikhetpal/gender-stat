require 'rails_helper'

RSpec.describe UserGenerateService, type: :service do
  let!(:user_api_url) { ENV['NEW_USERS_URL'] }
  let!(:default_final_api_url) { user_api_url + "?results=20" }
  let!(:stub_api_response) {
    {
      "results": [{
        "gender": "male",
        "name": {
          "title": "Mr",
          "first": "Pacal",
          "last": "da Conceição"
        },
        "location": {
          "street": {
            "number": 6718,
            "name": "Rua Castro Alves "
          },
          "city": "Coronel Fabriciano",
          "state": "Amapá",
          "country": "Brazil",
          "postcode": 52502,
          "coordinates": {
            "latitude": "-75.0029",
            "longitude": "-80.8041"
          },
          "timezone": {
            "offset": "+3:00",
            "description": "Baghdad, Riyadh, Moscow, St. Petersburg"
          }
        },
        "email": "pacal.daconceicao@example.com",
        "login": {
          "uuid": "c38a2417-7253-42c0-9a61-3d3eed131b32",
          "username": "happybutterfly276",
          "password": "nomore",
          "salt": "CiuoiYag",
          "md5": "1c8f3d851c8f6bc1a29a5f9d35ac97f2",
          "sha1": "3a7a76c6af98d3981b4d18f1d8003d47d611949d",
          "sha256": "cfd32bd31a0de4247125e11f8a33cc26938863bd2634b00b4d4ef7c3f82ccc6d"
        },
        "dob": {
          "date": "1991-01-04T22:30:53.529Z",
          "age": 33
        },
        "registered": {
          "date": "2006-08-31T12:56:35.959Z",
          "age": 17
        },
        "phone": "(98) 0106-1146",
        "cell": "(55) 9081-6117",
        "id": {
          "name": "CPF",
          "value": "715.305.531-59"
        },
        "picture": {
          "large": "https://randomuser.me/api/portraits/men/90.jpg",
          "medium": "https://randomuser.me/api/portraits/med/men/90.jpg",
          "thumbnail": "https://randomuser.me/api/portraits/thumb/men/90.jpg"
        },
        "nat": "BR"
      }]
    }.with_indifferent_access
  }

  before { allow(HTTParty).to receive(:get).and_return(stub_api_response) }

  describe '#initialize' do   
    it 'sets count and final_api_url based on default count as 20' do
      service = UserGenerateService.new
      expect(service.final_api_url).to eq(default_final_api_url)
      expect(service.count).to eq(20)
    end

    it 'sets count and final_api_url based on count initialized' do
      service = UserGenerateService.new(10)
      final_url = user_api_url + "?results=10"
      expect(service.final_api_url).to eq(final_url)
      expect(service.count).to eq(10)
    end
  end

  describe '#fetch_users' do
    it 'fetches users from the API' do      
      service = UserGenerateService.new(1)
      service.fetch_users

      expect(service.users).to be_an(Array)
      expect(service.users.first[:login][:uuid]).to eq(stub_api_response[:results].first[:login][:uuid])
    end
  end

  describe '#generate' do
    it 'creates users' do
      service = UserGenerateService.new(1)
      expect { service.generate }.to change { User.count }.by(1)

      expect(User.exists?(uuid: stub_api_response[:results].first[:login][:uuid])).to eq(true)
    end

    it 'updates user' do
      user = FactoryBot.create(:user, uuid: stub_api_response[:results].first[:login][:uuid])
      service = UserGenerateService.new(1)
      expect { service.generate }.to change { user.reload.name }
      expect { service.generate }.not_to change { User.count }
    end
  end
end
