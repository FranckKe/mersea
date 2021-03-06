class ReportsController < ApiController
  before_action :fetch_report, only: %i(show update destroy)

  def index
    @reports = Report.filter(params.permit(*parameters))
    @reports = policy_scope(@reports)

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

    @report.photo.attach(Uploads.call(params[:photo])) if params[:photo].present?

    @report.longitude = @report.longitude.round(4) if @report.longitude
    @report.latitude = @report.latitude.round(4) if @report.latitude

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
    params.permit(:tracer_id, :name, :quantity, :shore_length, :address, :longitude, :latitude,
                  :description, :reported_at)
  end

  def report_params_update
    params.permit(:name, :quantity, :shore_length, :address, :longitude, :latitude,
                  :description, :reported_at)
  end

  def parameters
    [
      :name, :tracer_id, :user_id, :reported_at, :r_min_reported_at, :r_max_reported_at
    ]
  end
end
