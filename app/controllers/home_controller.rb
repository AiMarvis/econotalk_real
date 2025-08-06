class HomeController < ApplicationController
  # Allow non-authenticated users to view home page
  skip_before_action :authenticate_user!, only: [:index]
  def index
    # Fetch featured content (latest 6 contents)
    @featured_contents = Content.includes(:user, :tags, thumbnail_attachment: :blob)
                                .order(created_at: :desc)
                                .limit(6)
    
    # Get content counts by category for the category section
    @category_counts = {
      '주식투자' => Content.joins(:tags).where(tags: { name: ['주식', '투자전략', 'ETF', '배당'] }).distinct.count,
      '부동산' => Content.joins(:tags).where(tags: { name: '부동산' }).count,
      '암호화폐' => Content.joins(:tags).where(tags: { name: '암호화폐' }).count,
      '세금/절세' => Content.joins(:tags).where(tags: { name: ['세금', '절세'] }).count
    }
  end
end
