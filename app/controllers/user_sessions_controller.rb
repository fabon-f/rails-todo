class UserSessionsController < ApplicationController
  def new
  end

  def create
    if @user = login(params[:email].downcase, params[:password])
      redirect_back_or_to(:root, success: 'Login successful')
    else
      flash.now[:error] = 'Invalid email or password'
      render action: 'new'
    end
  end

  def destroy
    logout
    redirect_to(:root, success: 'Logged out!')
  end
end
