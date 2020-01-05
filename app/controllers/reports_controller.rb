class ReportsController < ApplicationController
  before_action :authenticate_user!
  
  #This action is responsible for displaying varios kinds of reports
  def view
    if params[:report_date].present? && params[:report_type].present?
      @report_contents = current_user.get_reports(params[:report_date], params[:report_type])
    else
      respond_to do |format|
        format.html { redirect_to current_user, method: :get, alert: 'Either report date or report type is empty' }
        format.json { render :show, status: :bad_request, location: @user }
      end
    end
  end
  
  private
  def report_params
    params.permit(:report_date, :report_type)
  end
  
end
