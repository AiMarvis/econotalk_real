require "test_helper"

class BookmarkTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @content = contents(:one)
  end
  
  test "should create bookmark with valid user and content" do
    bookmark = Bookmark.new(user: @user, content: @content)
    assert bookmark.save
  end
  
  test "should not allow duplicate bookmarks for same user and content" do
    # Create first bookmark
    bookmark1 = Bookmark.create!(user: @user, content: @content)
    
    # Try to create duplicate
    bookmark2 = Bookmark.new(user: @user, content: @content)
    assert_not bookmark2.valid?
    assert bookmark2.errors[:user_id].present?
  end
  
  test "should allow same content to be bookmarked by different users" do
    user2 = users(:two)
    
    bookmark1 = Bookmark.create!(user: @user, content: @content)
    bookmark2 = Bookmark.new(user: user2, content: @content)
    
    assert bookmark2.save
  end
  
  test "should allow same user to bookmark different contents" do
    content2 = contents(:two)
    
    bookmark1 = Bookmark.create!(user: @user, content: @content)
    bookmark2 = Bookmark.new(user: @user, content: content2)
    
    assert bookmark2.save
  end
end
