class FeedController < ApplicationController
  # Allow non-authenticated users to view feeds
  skip_before_action :authenticate_user!, only: [:index, :explore]
  def index
    # 콘텐츠를 최신 순으로 정렬하고 연관된 데이터 포함 (N+1 쿼리 방지)
    @pagy, @contents = pagy(
      Content.includes(:user, :tags, thumbnail_attachment: :blob)
             .order(created_at: :desc),
      limit: 10
    )
    
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end
  
  def explore
    # 탐색 페이지 - 태그별 필터링 기능 추가 예정
    @pagy, @contents = pagy(
      Content.includes(:user, :tags, thumbnail_attachment: :blob)
             .order(created_at: :desc),
      limit: 10
    )
    
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end
end