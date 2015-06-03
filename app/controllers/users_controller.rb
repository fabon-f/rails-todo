class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    password = @user.password
    if @user.save
      login(@user.email, password)
      flash[:success] = "Welcome to the #{view_context.site_name}!"
      redirect_to user_url(@user.username)
    else
      render 'new'
    end
  end

  def index
    
  end

  def show
    @user = User.find_by(username: params[:username])
  end

  private def user_params
    params.require(:user).permit(:email, :username, :password, :password_confirmation)
  end
end
