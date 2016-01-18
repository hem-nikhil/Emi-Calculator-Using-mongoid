class User 
	include Mongoid::Document
	field :email , type: String
	
	has_many :emi_enquiries
	validates :email, presence: true, email: true
	validates_uniqueness_of :email 

	class << self
		def get_user_info
			user_info = {}
			users = includes(:emi_enquiries).all
			users.each do |user|
				user_info[user.id] = {}
				user_info[user.id][:email] = user.email
				user_info[user.id][:emi_enquiries] = user.emi_enquiries
			end
			user_info
		end
	end
end
