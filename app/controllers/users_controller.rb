class UsersController < ApplicationController
  before_action :require_login, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    password = @user.password
    if @user.save
      login(@user.email, password)
      flash[:success] = "Welcome to the #{Settings.site_name}!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def index
    
  end

  def edit
    # Look at correct_user
  end

  def update
    # look at correct_user
    if @user.correct_password? params[:user][:current_password]
      if @user.update_attributes(user_params)
        flash[:success] = "Profile updated"
        redirect_to @user
      else
        render 'edit'
      end
    else
      flash.now[:error] = 'Current password is incorrect'
      render 'edit'
    end
  end

  def show
    @user = User.find_by(username: params[:username])
  end

  private def user_params
    params.require(:user).permit(:email, :username, :password, :password_confirmation)
  end

  private def correct_user
    @user = User.find_by(username: params[:username])
    redirect_to root_url unless current_user == @user
  end
end
