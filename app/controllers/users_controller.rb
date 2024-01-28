class UsersController < ApplicationController
  before_action :set_users_data, only: %i(index)
  before_action :fetch_user, only: %i(destroy)

  def index
    @liquid_template = Liquid::Template.parse(File.read(Rails.root.join('app/views/users/index.liquid')))
  end

  def destroy
    @user.destroy
  end

  private

  def set_users_data
    unless params[:search].present?
      users = User.all
    else
      users = User.search(params[:search])
    end

    @users = users.map do |user|
      {
        'full_name' => user.full_name,
        'age' => user.age,
        'gender' => user.gender,
        'created_at' => user.created_at.strftime("%d %B %Y %M:%S %p"),
        'id' => user.id
      }
    end
  end

  def fetch_user
    @user = User.find(params[:id])
  end
end
