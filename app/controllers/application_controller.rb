class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :fetch_pages

  def status
    render json: {}, status: :ok
  end

  private

  def fetch_pages
    @pages = Page.all # For side menu
  end
end
