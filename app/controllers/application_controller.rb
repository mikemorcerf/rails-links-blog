class ApplicationController < ActionController::Base
  before_action :only_admin_user

  def only_admin_user
    redirect_to root_url if user_signed_in? && current_user.email != ENV.fetch('ADMIN_EMAIL')
  end
end
