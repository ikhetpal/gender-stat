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
  end
end
