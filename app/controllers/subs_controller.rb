class SubsController < ApplicationController
  include ApplicationHelper
  before_filter :authenticate_user!, :except => [:index, :all, :show]
  before_action :set_sub, only: [:show, :edit, :update, :destroy]

  # GET /subs
  # GET /subs.json
  def index
    if user_signed_in?
      @subs = current_user.subscriptions
      @posts = current_user.feed
    else
      # switch to default subs in the future
      @subs = Sub.all
      @posts = Post.all
    end

    @posts = get_posts(@posts, params[:tag], params[:d], params[:f])
  end

  def all
    @subs = Sub.all
    @posts = get_posts(nil, params[:tag], params[:d], params[:f])
    #@posts = @posts.page(params[:page]).per(25)
  end

  def random
    offset = rand(Sub.count)
    rand_record = Sub.offset(offset).first

    redirect_to rand_record
  end

  # GET /subs/1
  # GET /subs/1.json
  def show
    @posts = @sub.posts
  end

  # GET /subs/new
  def new
    @sub = Sub.new
  end

  # GET /subs/1/edit
  def edit
  end

  # POST /subs
  # POST /subs.json
  def create
    @sub = current_user.creations.create(sub_params)
    @sub.creator = current_user
    @sub.creator.subscribe(@sub)

    respond_to do |format|
      if @sub.save
        format.html { redirect_to @sub, notice: 'Sub was successfully created.' }
        format.json { render action: 'show', status: :created, location: @sub }
      else
        format.html { render action: 'new' }
        format.json { render json: @sub.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subs/1
  # PATCH/PUT /subs/1.json
  def update
    respond_to do |format|
      if @sub.update(sub_params)
        format.html { redirect_to @sub, notice: 'Sub was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit', notice: @sub.errors }
        format.json { render json: @sub.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subs/1
  # DELETE /subs/1.json
  def destroy
    @sub.destroy
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sub
      @sub = Sub.find_by_name(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sub_params
      params.require(:sub).permit(:name, :title, :description)
    end
end
