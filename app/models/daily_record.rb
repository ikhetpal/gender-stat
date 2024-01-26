class DailyRecord < ApplicationRecord
	validates :male_count, :female_count, numericality: { greater_than_or_equal_to: 0, only_integer: true }
	validates :male_avg_age, :female_avg_age, numericality: { greater_than_or_equal_to: 0 }
end
