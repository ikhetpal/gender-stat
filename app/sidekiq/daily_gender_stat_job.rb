class DailyGenderStatJob
  include Sidekiq::Job

  attr_accessor :daily_record, :redis_male_count, :redis_female_count

  def initialize
    @daily_record = DailyRecord.find_by(date: Date.yesterday)
    @redis_male_count = RedisUtility.fetch_data('male_count')
    @redis_female_count = RedisUtility.fetch_data('female_count')
  end

  def perform
    return if daily_record.nil?
    
    daily_record.update(male_count: redis_male_count, female_count: redis_female_count)
    reset_redis_data
  end

  private

  def reset_redis_data
    RedisUtility.reset_count('male_count')
    RedisUtility.reset_count('female_count')
  end
end
