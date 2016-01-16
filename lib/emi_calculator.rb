class EmiCalculator
	require 'date'
	
	# calculate month wise emi summary 
	def self.calculate_summary_for_months(principal_amount,rate_of_intrest,number_of_months,emi)
		principal = principal_amount
		total_interest = 0
		total_principal = 0
		emi_summary_for_months = {}
		emi_summary_for_months[:months] = {}
		time = Time.now
		curr_month = time.month
		curr_year = time.year
		roi_per_month = rate_of_intrest.to_f/(12*100)
		(1..number_of_months).each do |month|
			
			emi_summary_for_months[:months][month] = {}
			intrest_per_month = principal * roi_per_month
			principal_amount_per_month = emi  - intrest_per_month
			principal = principal - principal_amount_per_month
			total_interest = total_interest + intrest_per_month
			total_principal = total_principal + principal_amount_per_month

			#month name calculation
			month_name = "#{Date::MONTHNAMES[curr_month]} #{curr_year}"
			curr_month = curr_month + 1
			if(curr_month > 12 )
				curr_month = 1
				curr_year = curr_year + 1
			end

			emi_summary_for_months[:months][month][:intrest_per_month] = intrest_per_month
			emi_summary_for_months[:months][month][:principal_amount_per_month] = principal_amount_per_month
			emi_summary_for_months[:months][month][:total_interest] = total_interest
			emi_summary_for_months[:months][month][:total_principal] = total_principal
			emi_summary_for_months[:months][month][:month_name] = month_name
		end
		emi_summary_for_months
	end

	# calculate emi from given data 
	def self.calculate_emi(params)
		principal_amount,rate_of_intrest,number_of_months = params[:principal_amount].to_f,params[:rate_of_intrest].to_f,params[:number_of_months].to_i
		roi_per_month = rate_of_intrest.to_f/(12*100)
		temp = (1+roi_per_month)**number_of_months
		emi = principal_amount * roi_per_month * (temp/(temp-1))
		total_payable_amount = emi * number_of_months
		total_intrest_paid = total_payable_amount - principal_amount

		puts "EMI FOR MONTH:: #{emi}"
		puts "total_payable_amount :: #{total_payable_amount}"
		puts "total_intrest_paid :: #{total_intrest_paid}"
		emi_summary = calculate_summary_for_months(principal_amount,rate_of_intrest,number_of_months,emi)
		emi_summary.merge!({principal_amount: principal_amount,rate_of_intrest:rate_of_intrest,number_of_months: number_of_months,
							total_payable_amount:total_payable_amount,total_intrest_paid:total_intrest_paid,emi: emi})
		emi_summary
	end
end
