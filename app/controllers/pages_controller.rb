class PagesController < ApiController
  def index
    @pages = Page.order(:name).all
    render json: @pages, status: :ok
  end

  def show
    @page = Page.find(params[:id])
    render json: @page, status: :ok
  end

  def leaderboard
    @leaderboard = Rails.cache.fetch('leaderboard')
    fetch_leaderboard unless @leaderboard
    render json: @leaderboard
  end

  private

  def fetch_leaderboard
    users = User.joins(:reports).group('users.id').having('count(users.id) > 0')
    @leaderboard = users.map do |user|
      { name: user.name,
        reports_count: user.reports.count,
        last_activity: user.reports.last.reported_at }
    end || []
    Rails.cache.write('leaderboard', @leaderboard, expires_in: 12.hours) unless @leaderboard.empty?
  end
end
