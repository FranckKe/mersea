class ReportsController < ApplicationController
  def index
    @reports = Report.where(status: 'accepted')
    render json: @reports, status: :ok
  end

  def show
  end

  def new
    @report = Report.new(name: current_user&.name)
  end

  def create
    @report = Report.new(report_params.merge(user: current_user))

    if verify_recaptcha(model: @report) && @report.save
      flash[:success] = 'Merci pour votre signalement'
      redirect_to root_path
    else
      flash[:alert] = @report.errors.messages.first
      redirect_to Tracer.find(params[:report][:tracer_id])
    end
  end

  private

  def report_params
    params.require(:report).permit(:tracer_id, :name, :email, :quantity, :address, :longitude,
                                   :latitude, :description, :photo, :reported_at)
  end
end
