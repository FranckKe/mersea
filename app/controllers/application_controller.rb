class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :fetch_pages, only: [:new, :index, :show]

  private

  def fetch_pages
    @pages = Page.all # For side menu
  end
end
