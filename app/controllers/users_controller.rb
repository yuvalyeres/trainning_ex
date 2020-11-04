class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_user_by_token, only: [:update, :sign_out]
  before_action :set_user_by_id, only: [:show]
  before_action :set_user_by_email_password, only: [:sign_in]

  def index
    @users = User.all
      render json: @users, except: :token
  end

  def show
    render json: @user, except: :token
  end

  def create
    @user = User.new(user_params)
    @user.token = SecureRandom.hex()

    if @user.save()
      render json: @user, except: :token
    else
      render plain: "Failed to create user", status: 500
    end
  end

  def update
    if @user.id != params[:id].to_i()
      render plain: "Can't edit other users", status: 401
    elsif @user.update(user_params)
      render json: @user, except: :token
    else
      render plain: "Failed to update user", status: 500
    end
  end

  def sign_in
    cookies[:token] = SecureRandom.hex()

    if @user.update(token: cookies[:token])
      render plain: "sign_in"
    else
      render plain: "Failed to signin", status: 500
    end
  end

  def sign_out
    cookies.delete :token
    @user.update(token: nil)

    render plain: "sign_out"
  end

  private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password)
    end

    def set_user_by_id
      # find_by returns nil when record not found while find throw an error
      @user = User.find_by(id: params[:id])

      if @user.blank?
        render plain: "Couldn’t find user with id #{params[:id]}", status: 404
      end
    end

    def set_user_by_email_password
      @user = User.find_by(email: params[:email], password: params[:password])

      if @user.blank?
        render plain: "Wrong email or password", status: 401
      end
    end
    
    def set_user_by_token
      if !cookies[:token].blank?
        @user = User.find_by(token: cookies[:token])
      else
        render plain: "No user signed in", status: 401
      end
    end
end
