class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  helper_method :current_user

  def index
    @current_user_posts = Post.where(user_id: current_user.id)
    @posts = Post.none
    current_user.followees.each do |fl|
      @posts |= fl.posts
    end
    @posts.sort_by{|e| e[:created_at]}
    @posts |= @current_user_posts

    @post = Post.new
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def edit
    respond_to do |format|
      format.turbo_stream do 
        render turbo_stream: [ turbo_stream.update(@post,
                                                 partial: "posts/form",
                                                 locals: {post: @post}) ]
      end
    end 
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    respond_to do |format|
      if @post.save
        format.turbo_stream do 
        end
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.turbo_stream do 
        end
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  #лучшая реализация потоков через сессию но пока не до этого https://www.colby.so/posts/conditional-rendering-with-turbo-stream-broadcasts
  # def clearance
  #   secret_clearance ? session.delete(:clearance) : session[:clearance] = true
  #   redirect_to posts_path
  # end

  #надо бы перенести в другое место или net, xz
  def like
    @post = Post.find(params[:id])
    current_user.like(@post)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: private_stream
      end
    end
  end

  def private_stream
    private_target = "#{helpers.dom_id(@post)} private_likes"
    turbo_stream.replace(private_target,
                         partial: "likes/private_button",
                         locals: {post: @post, 
                         like_status: current_user.liked?(@post), puk: true})
  end

  private

    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :body, images:[] )
    end
end