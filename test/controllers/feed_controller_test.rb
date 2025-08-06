require "test_helper"

class FeedControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get feed_url
    assert_response :success
    assert_select "h1", "피드"
  end

  test "should get explore" do
    get explore_url
    assert_response :success
    assert_select "h1", "탐색"
  end

  test "should respond to turbo_stream format" do
    get feed_url, headers: { "Accept" => "text/vnd.turbo-stream.html" }
    assert_response :success
  end

  test "should paginate contents" do
    # 테스트용 사용자 생성
    user = User.create!(email: "test@example.com", name: "Test User")
    
    # 15개의 테스트 콘텐츠 생성 (페이지당 10개이므로 2페이지)
    15.times do |i|
      Content.create!(
        title: "Test Content #{i + 1}",
        body: "Test body #{i + 1}",
        content_type: "column",
        user: user,
        link: "https://example.com/#{i + 1}"
      )
    end

    get feed_url
    assert_response :success
    
    # 첫 번째 페이지에는 10개의 콘텐츠가 있어야 함
    assert_select "article", 10
    
    # "더 보기" 링크가 있어야 함
    assert_select "a", text: "더 보기"
  end

  test "should handle pagination with pagy" do
    # 테스트용 사용자 생성
    user = User.create!(email: "test@example.com", name: "Test User")
    
    # 5개의 테스트 콘텐츠 생성
    5.times do |i|
      Content.create!(
        title: "Test Content #{i + 1}",
        body: "Test body #{i + 1}",
        content_type: "column",
        user: user,
        link: "https://example.com/#{i + 1}"
      )
    end

    get feed_url(page: 1)
    assert_response :success
    
    # 5개의 콘텐츠만 있으므로 "더 보기" 링크가 없어야 함
    assert_select "a", { text: "더 보기", count: 0 }
  end

  test "should include necessary data attributes for auto-load" do
    get feed_url
    assert_response :success
    
    # turbo_frame이 있어야 함
    assert_select "turbo-frame[id='contents']"
    
    # auto-load 컨트롤러가 있어야 함
    assert_select "[data-controller='auto-load']"
  end
end