class ApplicationController < ActionController::Base
  before_action :set_query
  helper_method :secret_clearance

  def secret_clearance
    session[:clearance].presence || false
  end

  def set_query
    @query = Post.ransack(params[:q])
  end
end
