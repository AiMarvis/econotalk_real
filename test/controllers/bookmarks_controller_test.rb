require "test_helper"

class BookmarksControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:one)
    @content = contents(:one)
  end

  test "should require authentication for create" do
    post content_bookmark_path(@content)
    assert_redirected_to new_user_session_path
  end

  test "should require authentication for destroy" do
    delete content_bookmark_path(@content)
    assert_redirected_to new_user_session_path
  end

  test "should create bookmark when authenticated" do
    sign_in @user
    
    assert_difference('Bookmark.count', 1) do
      post content_bookmark_path(@content), as: :turbo_stream
    end
    
    assert_response :success
    assert_match "bookmark_#{@content.id}", response.body
  end

  test "should destroy bookmark when authenticated" do
    sign_in @user
    bookmark = Bookmark.create!(user: @user, content: @content)
    
    assert_difference('Bookmark.count', -1) do
      delete content_bookmark_path(@content), as: :turbo_stream
    end
    
    assert_response :success
    assert_match "bookmark_#{@content.id}", response.body
  end

  test "should handle bookmark creation error gracefully" do
    sign_in @user
    # Create existing bookmark
    Bookmark.create!(user: @user, content: @content)
    
    assert_no_difference('Bookmark.count') do
      post content_bookmark_path(@content), as: :turbo_stream
    end
    
    assert_response :success
  end

  test "should show bookmarks index when authenticated" do
    sign_in @user
    get bookmarks_path
    assert_response :success
  end
end