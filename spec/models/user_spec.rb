require "rails_helper"

RSpec.describe User, type: :model do
  context "validations" do
    it { should validate_uniqueness_of(:uuid) }
    it { should validate_inclusion_of(:gender).in?(User::GENDERS) }
    it { should validate_numericality_of(:age).is_greater_than(0) }
  end

  context "methods" do
    it "returns current male count on calling #male_count" do
      FactoryBot.create_list(:user, 20, gender: 'male')
      expect(described_class.male_count).to eq(User.male.count)
    end

    it "returns current female count on calling #female_count" do
      FactoryBot.create_list(:user, 20, gender: 'female')
      expect(described_class.female_count).to eq(User.female.count)
    end

    it "returns male average age on calling #male_avg_age" do
      FactoryBot.create_list(:user, 20, gender: 'male')
      expect(described_class.male_avg_age).to eq(User.male.average(:age).to_f.round(2))
    end

    it "returns female average age on calling #female_avg_age" do
      FactoryBot.create_list(:user, 20, gender: 'female')
      expect(described_class.female_avg_age).to eq(User.female.average(:age).to_f.round(2))
    end

    context "#search_name" do
      let!(:user) { FactoryBot.create(:user, name: { "title": "Mr", "first": "Test", "last": "User" }) }

      it "returns users containing search string name on calling #search(name)" do
        FactoryBot.create_list(:user, 10, gender: 'male')
        expect(User.search('mr test user')).to include(user)
      end

      it "returns user's full name on calling #full_name" do
        expect(user.full_name).to eq("Mr Test User")
      end
    end
  end

  context "callbacks" do
    before { allow(RedisUtility).to receive(:store_data).and_return("OK") }

    it "will reduct daily record by 1 and updates avg age when a user is destroyed" do
      user = FactoryBot.create(:user, gender: 'male')
      daily_record = FactoryBot.create(:daily_record, male_count: 1, female_count: 0, male_avg_age: user.age.to_f, female_avg_age: 0)
      user.destroy
      daily_record = daily_record.reload
      expect(daily_record.male_count).to eq(0)
      expect(daily_record.male_avg_age).to eq(0)
    end
  end
end
