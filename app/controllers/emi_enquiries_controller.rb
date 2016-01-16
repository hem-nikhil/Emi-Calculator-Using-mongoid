class EmiEnquiriesController < ApplicationController
  # GET /emi_enquiries/new
  def new
    @emi_enquiry = EmiEnquiry.new

  end

  # POST /emi_enquiries
  def create
    @errors = {}
    @emi_enquiry = EmiEnquiry.new
    result = @emi_enquiry.create_emi_enquiry_for_user(emi_enquiry_params.merge(email: params[:emi_enquiry][:email]))
    if result[:success] 
      @emi_summary = result[:emi_summary]
      render :emi_summary and return
    end
    @errors = result[:err]
    render :new and return
  end
  
  # prints emi summary for given loan data
  def emi_summary
  end
  
  # calculates total intrest and total principal for given months
  def month_interest_summary
    if request.xhr?
      months = params[:number_of_months].to_i
      emi_month_summary = EmiCalculator.calculate_summary_for_months(params[:principal_amount].to_f,params[:rate_of_intrest].to_f,
                                                                months,params[:emi].to_f)
      response = {success: true, err: nil}
      response.merge!({total_interest: '%.2f' %emi_month_summary[:months][months][:total_interest] ,
        total_principal: '%.2f' %emi_month_summary[:months][months][:total_principal]})
      render :json => response 
    else
      redirect_to "/"
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def emi_enquiry_params
      params.require(:emi_enquiry).permit(:principal_amount, :rate_of_intrest, :number_of_months, :email)
    end
end
