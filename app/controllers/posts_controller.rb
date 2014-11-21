class PostsController < ApplicationController
	before_filter :authenticate_user!, only: [:new, :create, :up, :down]
	before_action :set_post, only: [:up, :down, :show, :edit, :update, :destroy]
	before_action :set_sub, only: [:index, :show, :new, :selfie, :create]

  def index
    redirect_to sub_path(@sub)
  end

  # GET /c/[:sub_id]/posts/[:id]
	def show
    @comments = Comment.all
    @comments = @comments.where("post_id = ?", @post.id)
    @comments = @comments.where("parent_id is null")
    @comments = @comments.order("cached_votes_score desc")
    #.page(params[:page]).per(25)

    @depth = 0
    @maxdepth = 2
	end

	# GET /c/[:sub_id]/posts/new
  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.create(post_params)
    @post.sub = @sub

    respond_to do |format|
      if @post.save
        format.html { redirect_to sub_post_path(@sub, @post) }
        format.json { render action: 'show', status: :created, location: @post }
      else
        format.html { render action: 'new' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def up
    if current_user.liked? @post
      @post.unliked_by current_user
    else
      @post.liked_by current_user
    end    

    respond_to do |format|
      format.js
    end   
  end

  def down
    if current_user.disliked? @post
      @post.undisliked_by current_user
    else
      @post.disliked_by current_user
    end

    respond_to do |format|
      format.js
    end
  end

	private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.friendly.find(params[:id])
    end

    def set_sub
    	@sub = Sub.find_by_name(params[:sub_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :url, :text)
    end
end