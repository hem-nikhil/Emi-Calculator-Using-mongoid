class EmiEnquiry 
	include Mongoid::Document
	field :principal_amount, type: Float
	field :rate_of_intrest, type: Float
	field :number_of_months, type: Integer
	field :emi , type: Integer
	
	belongs_to :user, inverse_of: :emi_enquiries
	validates :principal_amount,:rate_of_intrest,:number_of_months , presence: true , numericality: {greater_than: 0}
	attr_accessor :email



	# creates a new user if not present with its email  or fetch the same user
	# calculates emi and store in emi enquiry against the given user
	def create_emi_enquiry_for_user(params)
		user = User.find_or_create_by(email: params[:email]) 
	    errors = {}
	    if user.valid?
	      emi_enquiry = user.emi_enquiries.new(params)
	      if emi_enquiry.save
	        emi_summary = EmiCalculator.calculate_emi(params)
	        emi_enquiry.update(emi: emi_summary[:emi])
	        return {success: true, emi_summary:emi_summary}
	      else
	         errors = emi_enquiry.errors.messages
	      end
	    else
	        errors = user.errors.messages
	    end
	    return {success: false,err: errors}
	end

end
