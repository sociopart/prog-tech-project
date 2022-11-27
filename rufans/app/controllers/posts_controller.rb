class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  helper_method :current_user

  def index
    @posts = Post.order(created_at: :desc)
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
        @post.create_post(current_user, @post)
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
          @post.update_post(current_user, @post)
        end
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.turbo_stream do 
          render turbo_stream: [ turbo_stream.update(@post,
                                                   partial: "posts/form",
                                                   locals: {post: @post}) ]
        end
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

  def clearance
    secret_clearance ? session.delete(:clearance) : session[:clearance] = true
    redirect_to posts_path
  end

  private

    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :body, images:[] )
    end
end