require 'dotenv/load'

class UserGenerateService
  attr_accessor :count, :users

  FETCH_USERS_URL = ENV['NEW_USERS_URL']

  def initialize(count = 20)
    @count = count
    @final_api_url = FETCH_USERS_URL + "?results=#{@count}"
  end

  def generate
    fetch_users

    users.each_slice(20) do |batch|
      batch.each { |u| create_or_update_user(u) }
    end
  end

  def fetch_users
    response = HTTParty.get(@final_api_url)
    @users = response['results'].map(&:with_indifferent_access) if response.present?
  end

  private

  def create_or_update_user(data)
    user = User.find_or_initialize_by(uuid: data[:login][:uuid])
    user.assign_attributes(gender: data[:gender], name: data[:name], location: data[:location], age: data[:registered][:age]) rescue nil
    user.save
  end
end
