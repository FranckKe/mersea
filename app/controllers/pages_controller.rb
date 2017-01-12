class PagesController < ApplicationController
  def index
    @pages = Page.all
  end

  def show
    @pages = Page.all # For side menu
    @page = Page.find(params[:id])
  end
end
