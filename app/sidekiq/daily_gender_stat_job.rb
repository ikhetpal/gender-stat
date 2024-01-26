class DailyGenderStatJob
  include Sidekiq::Job

  attr_accessor :daily_record, :redis_male_count, :redis_female_count

  def initialize
    @daily_record = DailyRecord.find_by(date: Date.yesterday)
    @redis_male_count = RedisUtility.fetch_data('male_count')
    @redis_female_count = RedisUtility.fetch_data('female_count')
  end

  # reset redis male_count and female_count & update daily record if the data has not been updated
  def perform
    return if daily_record.nil?
    
    daily_record.assign_gender_count(redis_male_count, redis_female_count)
    daily_record.save
    reset_redis_data
  end

  private

  def reset_redis_data
    RedisUtility.reset_count('male_count')
    RedisUtility.reset_count('female_count')
  end
end
