class TracersController < ApplicationController
  def index
    @tracers = Tracer.all
  end

  def show
    @tracer = Tracer.find(params[:id])
  end
end
