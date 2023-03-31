class ApplicationController < ActionController::Base
  before_action :set_query
  helper_method :secret_clearance
  helper_method :current_user

  def secret_clearance
    session[:clearance].presence || false
  end

  def set_current_user_for_action_cable
    current_user
  end

  def set_query
    @query = Post.ransack(params[:q])
  end
end
