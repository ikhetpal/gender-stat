class AddUsersJob
  include Sidekiq::Job

  attr_accessor :count

  def initialize(count: 20)
    @count = count
  end

  def perform
    UserGenerateService.new(count).generate
    update_redis
  end

  private

  def update_redis
    RedisUtility.store_data('male_count', User.male.count)
    RedisUtility.store_data('female_count', User.female.count)
  end
end
