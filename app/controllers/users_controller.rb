class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @users = User.all
    render json: @users
  end

  def show
    # find_by returns nil when record not found while find throw an error
    @user = User.find_by(id: params[:id])

    if @user
      render json: @user
    else
      render plain: "Couldn’t find user with id #{params[:id]}", status: 404
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save()
      render json: @user
    else
      render plain: "Failed to create user", status: 500
    end
  end

  private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email)
    end
end
