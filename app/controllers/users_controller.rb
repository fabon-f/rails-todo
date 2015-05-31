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
      redirect_to root_url
    else
      render 'new'
    end
  end

  def index
    
  end

  private def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
