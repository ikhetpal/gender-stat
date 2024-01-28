class User < ApplicationRecord
  GENDERS = %w(male female)

  validates :uuid, uniqueness: true
  validates :gender, inclusion: { in: GENDERS }
  validates :age, numericality: { greater_than: 0 }

  scope :male, -> { where(gender: 'male') }
  scope :female, -> { where(gender: 'female') }

  after_destroy :update_daily_record

  def full_name
    begin
      data = self.name.with_indifferent_access
      title = data[:title]
      first = data[:first]
      last = data[:last]

      return "#{title} #{first} #{last}"
    rescue
      ""
    end
  end

  def self.search(name)
    return all if name.blank?

    search_arr = name.strip.split(' ')
    queries = []
    keys = HashWithIndifferentAccess.new
    search_arr.each_with_index do |val, i|
      keys["val#{i}"] = "%#{val}%"
      queries << "name::text ILIKE :val#{i}"
    end

    where(queries.join(' AND '), keys)
  end

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

  private

  def update_daily_record
    key = "#{self.gender}_count"

    begin
      daily_record = DailyRecord.find_by(date: Date.current)
      current_count = daily_record.send(key)
      final_count = current_count.positive? ? (current_count - 1) : 0
      daily_record.send("#{key}=", final_count)
      daily_record.assign_avg_age
      daily_record.save
      RedisUtility.store_data(key, final_count)
    rescue
      nil
    end
  end
end
