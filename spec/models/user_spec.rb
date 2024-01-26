require "rails_helper"

RSpec.describe User, type: :model do
  context "validations" do
    it { should validate_uniqueness_of(:uuid) }
    it { should validate_inclusion_of(:gender).in?(User::GENDERS) }
    it { should validate_numericality_of(:age).is_greater_than(0) }
  end

  context "methods" do
    it "returns current male count on calling #male_count" do
      FactoryBot.create(:user, gender: 'male')
      expect(described_class.male_count).to eq(User.male.count)
    end

    it "returns current female count on calling #female_count" do
      FactoryBot.create(:user, gender: 'female')
      expect(described_class.female_count).to eq(User.female.count)
    end
  end
end
