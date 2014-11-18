class UsersController < ApplicationController
	before_action :set_user


	def show

	end

	private

		def set_user
			if signed_in? && params[:id] == current_user.username
				@user = current_user
			else
				@user = User.find_by_username(params[:id])
			end
		end	

end