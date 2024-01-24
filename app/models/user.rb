class User < ApplicationRecord
	GENDERS = %w(male female)

	validates :uuid, uniqueness: true
	validates :gender, inclusion: { in: GENDERS }
	validates :age, numericality: { greater_than: 0 }
end
