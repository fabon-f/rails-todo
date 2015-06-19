class Admin::BaseController < ApplicationController
  before_action :admin_user
  private def admin_user
    redirect_to root_path, flash: { error: 'You are not admin user' } unless current_user.admin?
  end
end
