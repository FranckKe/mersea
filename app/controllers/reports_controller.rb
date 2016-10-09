class ReportsController < ApplicationController
  def index
  end

  def show
  end

  def new
    @report = Report.new
  end

  def create
    @report = Report.new(report_params)

    if @report.save
      flash.now[:success] = 'Merci pour votre signalement'
      redirect_to root_path
    else
      flash.now[:alert] = @report.errors.messages.first
      redirect_to Tracer.find(params[:report][:tracer_id])
    end
  end

  private

  def report_params
    params.require(:report).permit(:tracer_id, :name, :email, :quantity, :address, :longitude,
                                   :latitude, :description, :photo, :reported_at)
  end
end
