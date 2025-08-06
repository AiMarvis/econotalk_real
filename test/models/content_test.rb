require "test_helper"

class ContentTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @content = Content.new(
      title: "Test Economic Article",
      body: "This is a test economic article about market trends.",
      content_type: "column",
      user: @user
    )
  end

  test "should be valid with valid attributes" do
    assert @content.valid?
  end

  test "should require title" do
    @content.title = ""
    assert_not @content.valid?
    assert_includes @content.errors[:title], "can't be blank"
  end

  test "should require body" do
    @content.body = ""
    assert_not @content.valid?
    assert_includes @content.errors[:body], "can't be blank"
  end

  test "should require content_type" do
    @content.content_type = nil
    assert_not @content.valid?
    assert_includes @content.errors[:content_type], "can't be blank"
  end

  test "should accept valid URL for link" do
    @content.link = "https://example.com/article"
    assert @content.valid?
  end

  test "should reject invalid URL for link" do
    @content.link = "invalid-url"
    assert_not @content.valid?
    assert_includes @content.errors[:link], "is invalid"
  end

  test "should have one attached thumbnail" do
    assert_respond_to @content, :thumbnail
    assert @content.thumbnail.is_a?(ActiveStorage::Attached::One)
  end

  test "thumbnail should not be attached initially" do
    @content.save!
    assert_not @content.thumbnail.attached?
  end

  test "can attach thumbnail image" do
    @content.save!
    
    # Create a test image file
    image_file = fixture_file_upload("test_image.png", "image/png")
    @content.thumbnail.attach(image_file)
    
    assert @content.thumbnail.attached?
    assert_equal "image/png", @content.thumbnail.content_type
  end

  test "thumbnail_url returns nil when no thumbnail attached" do
    @content.save!
    assert_nil @content.thumbnail_url
  end

  test "thumbnail_url returns path when thumbnail attached" do
    @content.save!
    image_file = fixture_file_upload("test_image.png", "image/png")
    @content.thumbnail.attach(image_file)
    
    assert_not_nil @content.thumbnail_url
    assert @content.thumbnail_url.include?("/rails/active_storage/blobs/")
  end

  test "description truncates body to 200 characters" do
    long_body = "A" * 250
    @content.body = long_body
    @content.save!
    
    assert_equal 200, @content.description.length # truncate limits to exactly 200 chars including "..."
    assert @content.description.end_with?("...")
  end

  test "author returns user name or email" do
    @user.name = "John Doe"
    assert_equal "John Doe", @content.author
    
    @user.name = nil
    @user.email = "john@example.com"
    assert_equal "john@example.com", @content.author
  end

  test "url returns link if present, otherwise content path" do
    @content.link = "https://example.com"
    @content.save!
    assert_equal "https://example.com", @content.url
    
    @content.link = nil
    expected_path = Rails.application.routes.url_helpers.content_path(@content)
    assert_equal expected_path, @content.url
  end

  private

  def fixture_file_upload(filename, content_type)
    # Create a temporary file for testing
    file_path = Rails.root.join("test", "fixtures", "files", filename)
    
    # Create the directory if it doesn't exist
    FileUtils.mkdir_p(File.dirname(file_path))
    
    # Create a simple PNG file for testing if it doesn't exist
    unless File.exist?(file_path)
      # Create a 1x1 PNG image (minimal valid PNG)
      png_data = [
        0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, # PNG signature
        0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52, # IHDR chunk
        0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, # 1x1 dimensions
        0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, # bit depth, color type, etc.
        0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44, 0x41, # IDAT chunk
        0x54, 0x78, 0x9C, 0x62, 0x00, 0x01, 0x00, 0x00, # compressed image data
        0x05, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, # IEND chunk
        0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82
      ].pack('C*')
      
      File.binwrite(file_path, png_data)
    end
    
    Rack::Test::UploadedFile.new(file_path, content_type)
  end
end
