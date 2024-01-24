require "rails_helper"

RSpec.describe User, type: :model do
  context "validations" do
    it { should validate_uniqueness_of(:uuid) }
    it { should validate_inclusion_of(:gender).in?(User::GENDERS) }
    it { should validate_numericality_of(:age).is_greater_than(0) }
  end
end
