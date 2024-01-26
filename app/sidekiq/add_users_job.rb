class AddUsersJob
  include Sidekiq::Job

  attr_accessor :count, :current_male_count, :current_female_count, :current_daily_record

  def initialize(count: 20)
    @count = count
    @current_male_count = User.male_count
    @current_female_count = User.female_count
    @current_daily_record = DailyRecord.find_or_create_by(date: Date.current)
  end

  def perform
    UserGenerateService.new(count).generate
    update_records
  end

  private

  def update_records
    update_redis
    update_daily_record
  end

  def update_redis
    final_male_count = User.male_count
    final_female_count = User.female_count

    male_added_count = final_male_count - current_male_count
    female_added_count = final_female_count - current_female_count

    RedisUtility.append_count('male_count', male_added_count)
    RedisUtility.append_count('female_count', female_added_count)
  end

  def update_daily_record
    redis_male_count = RedisUtility.fetch_data('male_count')
    redis_female_count = RedisUtility.fetch_data('female_count')

    current_daily_record.update(male_count: redis_male_count, female_count: redis_female_count)
  end
end
