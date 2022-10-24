class UsersController < ApplicationController
  before_action :set_user
  def profile
    # @user.update(views: @user.views + 1)
    # @posts = @user.posts.includes(:rich_text_body).order(created_at: :desc)
    # @total_views = 0

    # @posts.each do |post|
    #   @total_views += post.views
    # end
    @post = Post.new
    @posts = Post.where("user_id = #{@user.id}")
  end

  private

  def set_user
    @user = User.find_by(user_tag: params[:user_tag])
  end

  def post_params
    params.require(:post).permit(:title, :body, :user_id, :images, :user_tag)
  end
end