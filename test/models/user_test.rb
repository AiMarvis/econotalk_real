require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @content = contents(:one)
  end

  test "bookmarked? should return false when user has not bookmarked content" do
    assert_not @user.bookmarked?(@content)
  end

  test "bookmarked? should return true when user has bookmarked content" do
    Bookmark.create!(user: @user, content: @content)
    assert @user.bookmarked?(@content)
  end

  test "should have bookmarked_contents through bookmarks" do
    content2 = contents(:two)
    
    Bookmark.create!(user: @user, content: @content)
    Bookmark.create!(user: @user, content: content2)
    
    assert_includes @user.bookmarked_contents, @content
    assert_includes @user.bookmarked_contents, content2
    assert_equal 2, @user.bookmarked_contents.count
  end
end
