class CommentsController < ApplicationController
  before_action :set_comment, only: %i[ show edit update destroy ]

  # GET /comments or /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1 or /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
    post = Post.find(params[:post_id])
    respond_to do |format|
      format.turbo_stream do 
        render turbo_stream: [ turbo_stream.update(@comment,
                                                  partial: "comments/form",
                                                  locals: {comment: @comment, post: @comment.post, parent: @comment.parent}) ]
      end
    end 
  end

  # POST /comments or /comments.json
  def create
    @post = Post.find(params[:post_id])

    @comment = @post.comments.create(comment_params)
    @comment.user_id = current_user.id
    respond_to do |format|
      if @comment.save
        format.turbo_stream do
        end
        format.html { redirect_to comment_url(@comment), notice: "Comment was successfully created." }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1 or /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.turbo_stream do 
        end
        format.html { redirect_to @comment, notice: "Comment was successfully updated." }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1 or /comments/1.json
  def destroy
    @comment.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:body, :parent_id)
    end
end
