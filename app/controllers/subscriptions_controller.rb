class SubscriptionsController < ApplicationController
	before_filter :authenticate_user!

	def create
		@sub = Sub.find(params[:sub_id])
    current_user.subscribe(@sub)
    respond_to do |format|
      format.html { redirect_to @sub }
      format.js
    end
	end

	def destroy
		@sub = Subscription.find(params[:id]).sub
    current_user.unsubscribe(@sub)
    respond_to do |format|
      format.html { redirect_to @sub }
      format.js
    end
	end
end
