class UserController < ApplicationController

	# display all users along with their emi enquires
	def show
		@user_info = User.get_user_info
		
	end
end
