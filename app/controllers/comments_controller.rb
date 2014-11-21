class CommentsController < ApplicationController
	before_filter :authenticate_user!, :except => [:children]
	before_filter :set_comment, :except => [:create]
	before_action :set_sub, only: [:create]

	def reply
		respond_to do |format|
			format.js
		end
	end

	def children
		@comments = @comment.children

		respond_to do |format|
			format.js
		end
	end

	def create
		post = Post.find(params[:comment][:post_id])

		if post.nil?
			redirect_to sub_path(@sub), :notice => ""
			return
		end

		@comment = Comment.new
		@comment.update_attributes(comment_params)
		@comment.user_id = current_user.id

		if @comment.save!
			respond_to do |format|
				format.html { redirect_to sub_post_path(@sub, @comment.post), :notice => "Your comment has been posted" }
				format.js
			end			
		else
			redirect_to sub_post_path(@sub, @comment.post), :notice => "Unable to post your comment"
		end
	end

	def like
		@comment.liked_by current_user

		respond_to do |format|
			format.js
		end		
	end

	def dislike
		@comment.disliked_by current_user

		respond_to do |format|
			format.js
		end
	end

	private
		def set_comment
			@comment = Comment.find_by_id(params[:id])
		end

		def set_sub
    	@sub = Sub.find_by_name(params[:sub_id])
    end

		def comment_params
			params.require(:comment).permit(:content, :post_id, :parent_id)
		end

end
