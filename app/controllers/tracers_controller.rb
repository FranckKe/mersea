class TracersController < ApplicationController
  def index
    @tracers = Tracer.order(:name).all
    render json: @tracers, status: :ok
  end

  def show
    @tracer = Tracer.find(params[:id])
    render json: @tracer, status: :ok
  end
end
