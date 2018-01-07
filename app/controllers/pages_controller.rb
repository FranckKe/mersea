class PagesController < ApplicationController
  def show
    @page = Page.find(params[:id])
  end

  def leaderboard
    @leaderboard = Rails.cache.fetch('leaderboard')
    return if @leaderboard
    users = User.joins(:reports).group('users.id').having('count(users.id) > 0')
    @leaderboard = users.each do |user|
      { name: user.name,
        reports_count: user.reports.count,
        last_activity: user.reports.last.reported_at }
    end || []
    Rails.cache.write('leaderboard', @leaderboard, expires_in: 12.hours) unless @leaderboard.empty?
  end
end
