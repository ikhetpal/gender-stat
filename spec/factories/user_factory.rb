FactoryBot.define do
  factory :user do
    uuid { Faker::Alphanumeric.unique.alphanumeric(number: 30) }
    gender { 'male' }
    name {
      {
        "title": "Mr",
        "first": Faker::Name.unique.first_name,
        "last": Faker::Name.unique.last_name
      }
    }
    location {
      {
        "street": {
          "number": 4631,
          "name": "Itsenäisyydenkatu"
        },
        "city": "Kirkkonummi",
        "state": "Southern Ostrobothnia",
        "country": "Finland",
        "postcode": 86582,
        "coordinates": {
          "latitude": "-27.9156",
          "longitude": "137.2998"
        },
        "timezone": {
          "offset": "+1:00",
          "description": "Brussels, Copenhagen, Madrid, Paris"
        }
      }
    }
    age { 25 }
  end
end