require 'rails_helper'
RSpec.describe AddUsersJob, type: :job do
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

  before do
    allow(HTTParty).to receive(:get).and_return(stub_api_response)
    allow(RedisUtility).to receive(:append_count).and_return('OK')
  end

  describe '#initialize' do   
    it 'sets default count as 20' do
      job = described_class.new
      expect(job.count).to eq(20)
    end

    it 'sets count to passed value' do
      job = described_class.new(count: 10)
      expect(job.count).to eq(10)
    end

    it 'sets current_male_count' do
      job = described_class.new
      expect(job.current_male_count).to eq(User.male_count)
    end

    it 'sets current_male_count' do
      job = described_class.new
      expect(job.current_female_count).to eq(User.female_count)
    end
  end

  describe '#perform' do
    it 'calls UserGenerateService to generate users' do
      expect { described_class.new(count: 1).perform }.to change { User.count }.by(1)
    end
  end
end
