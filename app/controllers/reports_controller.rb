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
      redirect_to root_path
    else
      flash.now[:alert] = @report.errors.messages.first
      render action: 'new'
    end
  end

  private

  def report_params
    params.permit(:tracer_id, :name, :email, :quantity, :address, :longitude,
      :latitude, :description, :photo, :reported_at)
  end
end
