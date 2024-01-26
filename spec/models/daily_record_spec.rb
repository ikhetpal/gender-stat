require "rails_helper"

RSpec.describe DailyRecord, type: :model do
  context "validations" do
    it { should validate_numericality_of(:male_count).is_greater_than_or_equal_to(0).only_integer.allow_nil }
    it { should validate_numericality_of(:female_count).is_greater_than_or_equal_to(0).only_integer.allow_nil }
    it { should validate_numericality_of(:male_avg_age).is_greater_than_or_equal_to(0).allow_nil }
    it { should validate_numericality_of(:female_avg_age).is_greater_than_or_equal_to(0).allow_nil }
  end
end
