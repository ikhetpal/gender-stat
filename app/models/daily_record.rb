class DailyRecord < ApplicationRecord
  include ActiveModel::Dirty

  validates :male_count, :female_count, numericality: { greater_than_or_equal_to: 0, only_integer: true }, allow_nil: true
  validates :male_avg_age, :female_avg_age, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  def assign_gender_count(redis_male_count, redis_female_count)
    self.assign_attributes(male_count: redis_male_count, female_count: redis_female_count)
    self.assign_avg_age
  end

  def assign_avg_age
    self.male_avg_age = User.male_avg_age if self.male_count_changed?
    self.female_avg_age = User.female_avg_age if self.female_count_changed?
  end
end
