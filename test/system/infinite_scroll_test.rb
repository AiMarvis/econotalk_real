require "application_system_test_case"

class InfiniteScrollTest < ApplicationSystemTestCase
  setup do
    # 테스트용 사용자 생성
    @user = User.create!(email: "test@example.com", name: "Test User")
    
    # 25개의 테스트 콘텐츠 생성 (페이지당 10개이므로 3페이지)
    25.times do |i|
      Content.create!(
        title: "Test Content #{i + 1}",
        body: "Test body #{i + 1}",
        content_type: "column",
        user: @user,
        link: "https://example.com/#{i + 1}"
      )
    end
  end

  test "infinite scroll should load more content automatically" do
    visit feed_path
    
    # 초기에는 10개의 콘텐츠가 보여야 함
    assert_selector "article", count: 10
    
    # "더 보기" 링크가 있어야 함
    assert_selector "a", text: "더 보기"
    
    # 페이지 하단으로 스크롤
    execute_script "window.scrollTo(0, document.body.scrollHeight)"
    
    # 잠시 대기 (IntersectionObserver가 작동할 시간)
    sleep 2
    
    # 더 많은 콘텐츠가 로드되어야 함 (20개)
    assert_selector "article", count: 20
  end

  test "should work on explore page" do
    visit explore_path
    
    # 초기에는 10개의 콘텐츠가 보여야 함
    assert_selector "article", count: 10
    
    # "더 보기" 링크가 있어야 함
    assert_selector "a", text: "더 보기"
    
    # 페이지 하단으로 스크롤
    execute_script "window.scrollTo(0, document.body.scrollHeight)"
    
    # 잠시 대기
    sleep 2
    
    # 더 많은 콘텐츠가 로드되어야 함
    assert_selector "article", count: 20
  end

  test "should not show more link when no more content" do
    # 5개의 콘텐츠만 생성
    Content.delete_all
    5.times do |i|
      Content.create!(
        title: "Test Content #{i + 1}",
        body: "Test body #{i + 1}",
        content_type: "column",
        user: @user,
        link: "https://example.com/#{i + 1}"
      )
    end
    
    visit feed_path
    
    # 5개의 콘텐츠만 보여야 함
    assert_selector "article", count: 5
    
    # "더 보기" 링크가 없어야 함
    assert_no_selector "a", text: "더 보기"
  end

  test "should handle manual click on more link" do
    visit feed_path
    
    # 초기에는 10개의 콘텐츠가 보여야 함
    assert_selector "article", count: 10
    
    # "더 보기" 링크를 수동으로 클릭
    click_link "더 보기"
    
    # 잠시 대기
    sleep 1
    
    # 더 많은 콘텐츠가 로드되어야 함
    assert_selector "article", count: 20
  end
end