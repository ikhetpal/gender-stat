class UsersController < ApplicationController
  before_action :set_users_data, only: %i(index)

  def index
    @liquid_template = Liquid::Template.parse(File.read(Rails.root.join('app/views/users/index.liquid')))
  end

  private

  def set_users_data
    users = User.all
    @users = users.map do |user|
      {
        'full_name' => user.full_name,
        'age' => user.age,
        'gender' => user.gender,
        'created_at' => user.created_at.strftime("%d %B %Y %M:%S %p")
      }
    end
  end
end
