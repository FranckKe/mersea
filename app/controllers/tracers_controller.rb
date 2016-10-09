class TracersController < ApplicationController
  def index
    @tracers = Tracer.all
  end

  def show
  end
end
