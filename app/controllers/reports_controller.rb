class ReportsController < ApplicationController
  def index
    @reports = Report.where(status: 'accepted')
    render json: @reports, status: :ok
  end

  def show
    @report = Report.find(params[:id])
    render json: @report, status: :ok
  end

  def new
    @report = Report.new(name: current_user&.name)
  end

  def create
    @report = Report.new(report_params.merge(user: current_user))

    if trusted_report && @report.save
      flash[:success] = 'Merci pour votre signalement'
      redirect_to root_path(locale: I18n.locale)
    else
      flash[:alert] = @report.errors.messages.first
      redirect_to Tracer.find(params[:report][:tracer_id])
    end
  end

  def update
    @report = Report.find(params[:id])

    if @report.update_attributes(report_params_update)
      render json: { report: @report, message: 'Témoignage mis à jour' }, status: :ok
    else
      render json: { message: @report.errors.full_messages }, status: :bad_request
    end
  end

  def edit
    @report = Report.find(params[:id])

    respond_to do |format|
      format.js { render layout: false, content_type: 'text/javascript' }
    end
  end

  def destroy
    @report = Report.find(params[:id])
    @report.destroy
    render json: { message: 'Témoignage supprimé' }, status: :ok
  end

  private

  def report_params
    params.require(:report)
          .permit(:tracer_id, :name, :quantity, :address, :longitude, :latitude,
                  :description, :photo, :reported_at)
  end

  def report_params_update
    params.require(:report)
          .permit(:name, :quantity, :address, :longitude, :latitude,
                  :description, :reported_at)
  end

  def trusted_report
    current_user.present? || verify_recaptcha(model: @report)
  end
end
