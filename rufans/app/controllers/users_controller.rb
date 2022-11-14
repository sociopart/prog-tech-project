class UsersController < ApplicationController
  include UsersHelper
  before_action :set_user
  def profile
    # @user.update(views: @user.views + 1)
    # @posts = @user.posts.includes(:rich_text_body).order(created_at: :desc)
    # @total_views = 0

    # @posts.each do |post|
    #   @total_views += post.views
    # end
    @post = Post.new
    @posts = Post.where("user_id = #{@user.id}").order(created_at: :desc)
  end

  def talantes
    @talantes = User.where(role:  "seller")
  end

  def follow
    @user = User.find(params[:id])
    Relationship.create_or_find_by(follower_id: current_user.id, followee_id: @user.id)
    respond_to do |format|
      format.turbo_stream do
        # john doe with a user id of 2
        # dom_id_for_follower(@user) -> user_2
        render turbo_stream: [
          turbo_stream.replace(dom_id_for_follower(@user),
                               partial: 'users/follow_button',
                               locals: { user: @user }),
          turbo_stream.update("#{@user.id}-follower-count",
                              partial: 'users/follower_count',
                              locals: { user: @user })
        ]
      end
    end
  end

  def unfollow
    @user = User.find(params[:id])
    current_user.followed_users.where(follower_id: current_user.id, followee_id: @user.id).destroy_all
    respond_to do |format|
      format.turbo_stream do
        # john doe with a user id of 2
        # dom_id_for_follower(@user) -> user_2
        render turbo_stream: [
          turbo_stream.replace(dom_id_for_follower(@user),
                               partial: 'users/follow_button',
                               locals: { user: @user }),
          turbo_stream.update("#{@user.id}-follower-count",
                              partial: 'users/follower_count',
                              locals: { user: @user })
        ]
      end
    end
  end

  private

  def set_user
    @user = User.find_by(user_tag: params[:user_tag])
  end

  def post_params
    params.require(:post).permit(:title, :body, :user_id, :images, :user_tag)
  end
end