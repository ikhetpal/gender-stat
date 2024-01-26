require "rails_helper"

RSpec.describe DailyRecord, type: :model do
  context "validations" do
    it { should validate_numericality_of(:male_count).is_greater_than_or_equal_to(0).only_integer.allow_nil }
    it { should validate_numericality_of(:female_count).is_greater_than_or_equal_to(0).only_integer.allow_nil }
    it { should validate_numericality_of(:male_avg_age).is_greater_than_or_equal_to(0).allow_nil }
    it { should validate_numericality_of(:female_avg_age).is_greater_than_or_equal_to(0).allow_nil }
  end

  context "methods" do
    describe "#assign_gender_count" do
      subject { FactoryBot.create(:daily_record) }

      it "updates gender count" do
        subject.assign_gender_count(10, 15)
        expect(subject.male_count).to eq(10)
        expect(subject.female_count).to eq(15)
      end

      it "updates gender average age" do
        FactoryBot.create_list(:user, 30, gender: 'male')
        FactoryBot.create_list(:user, 20, gender: 'female')
        subject.assign_gender_count(30, 20)
        expect(subject.male_avg_age).to eq(User.male_avg_age)
        expect(subject.female_avg_age).to eq(User.female_avg_age)
      end
    end
  end
end
