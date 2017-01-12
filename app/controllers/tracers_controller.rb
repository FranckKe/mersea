class TracersController < ApplicationController
  def index
    @tracers = Tracer.all
      respond_to do |format|
        format.html
        format.json { render json: @tracers, status: :ok }
    end
  end

  def show
    @tracer = Tracer.find(params[:id])
  end
end
