class User < ApplicationRecord
  GENDERS = %w(male female)

  validates :uuid, uniqueness: true
  validates :gender, inclusion: { in: GENDERS }
  validates :age, numericality: { greater_than: 0 }

  scope :male, -> { where(gender: 'male') }
  scope :female, -> { where(gender: 'female') }

  def self.male_count
    male.count
  end

  def self.female_count
    female.count
  end

  def self.male_avg_age
    male.average(:age).to_f.round(2) rescue nil
  end

  def self.female_avg_age
    female.average(:age).to_f.round(2) rescue nil
  end
end
