class AddUsersJob
  include Sidekiq::Job

  attr_accessor :count, :current_male_count, :current_female_count

  def initialize(count: 20)
    @count = count
    @current_male_count = User.male_count
    @current_female_count = User.female_count
  end

  def perform
    UserGenerateService.new(count).generate
    update_redis
  end

  private

  def update_redis
    final_male_count = User.male_count
    final_female_count = User.female_count

    male_added_count = final_male_count - current_male_count
    female_added_count = final_female_count - current_female_count

    RedisUtility.append_count('male_count', male_added_count)
    RedisUtility.append_count('female_count', female_added_count)
  end
end
