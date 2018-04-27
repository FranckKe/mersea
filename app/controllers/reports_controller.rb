class ReportsController < ApiController
  before_action :fetch_report, only: %i(show update destroy)

  def index
    @reports = Report.where(status: 'accepted')
    respond_to do |format|
      format.json { render json: @reports, status: :ok }
      format.geojson { render json: @reports, serializer: GeojsonReportsSerializer, status: :ok }
    end
  end

  def show
    respond_to do |format|
      format.json { render json: @report, status: :ok }
      format.geojson { render json: @report, serializer: GeojsonReportSerializer, status: :ok }
    end
  end

  def create
    @report = Report.new(report_params.merge(user: current_user))
    authorize @report

    @report.photo = Paperclip.io_adapters.for(params[:photo]) if params[:photo].present?
    if @report.save
      render json: @report, status: :created
    else
      @error = Mersea::Errors.format(@report.errors)
      render json: @error, status: @error.status
    end
  end

  def update
    @report.assign_attributes(report_params_update)

    if @report.save
      render json: @report, status: :ok
    else
      @error = Mersea::Errors.format(@report.errors)
      render json: @error, status: @error.status
    end
  end

  def destroy
    @report.destroy
    render nothing: true, status: :no_content
  end

  private

  def fetch_report
    @report = Report.find(params[:id])
    authorize @report
  end

  def report_params
    params.permit(:tracer_id, :name, :quantity, :address, :longitude, :latitude,
                  :description, :photo, :reported_at)
  end

  def report_params_update
    params.permit(:name, :quantity, :address, :longitude, :latitude,
                  :description, :reported_at)
  end
end
