require "application_system_test_case"

class ContentThumbnailUploadTest < ApplicationSystemTestCase
  setup do
    @user = User.create!(id: 1, name: "Test User", email: "test@example.com")
  end

  test "create content with thumbnail upload" do
    visit new_content_path

    fill_in "제목", with: "테스트 경제 기사"
    fill_in "내용", with: "이것은 썸네일을 포함한 테스트 경제 기사입니다."
    select "컬럼/기사", from: "콘텐츠 유형"
    fill_in "태그", with: "경제, 주식"

    # Test file upload
    test_image_path = create_test_image
    attach_file "content_thumbnail", test_image_path

    click_button "콘텐츠 생성"

    # Verify the content was created successfully
    assert_text "Content was successfully created"
    
    # Check that we're on the content show page
    content = Content.last
    assert_current_path content_path(content)
    
    # Verify the content appears on the page
    assert_text "테스트 경제 기사"
    assert_text "이것은 썸네일을 포함한 테스트 경제 기사입니다"
    
    # Verify thumbnail is attached in the database
    assert content.thumbnail.attached?
    assert_equal "image/png", content.thumbnail.content_type

    # Clean up
    File.delete(test_image_path) if File.exist?(test_image_path)
  end

  test "edit content and update thumbnail" do
    # Create initial content
    content = Content.create!(
      title: "기존 콘텐츠",
      body: "기존 내용입니다.",
      content_type: "column",
      user: @user
    )

    visit edit_content_path(content)

    # Verify form shows existing content
    assert_field "제목", with: "기존 콘텐츠"
    assert_field "내용", with: "기존 내용입니다."

    # Update with thumbnail
    test_image_path = create_test_image
    attach_file "content_thumbnail", test_image_path

    # Update some other fields as well
    fill_in "제목", with: "업데이트된 콘텐츠"
    fill_in "태그", with: "경제, 업데이트"

    click_button "콘텐츠 수정"

    # Verify the update was successful
    assert_text "Content was successfully updated"
    
    # Verify the updated content appears
    assert_text "업데이트된 콘텐츠"
    
    # Verify thumbnail is attached in the database
    content.reload
    assert content.thumbnail.attached?
    assert_equal "image/png", content.thumbnail.content_type

    # Clean up
    File.delete(test_image_path) if File.exist?(test_image_path)
  end

  test "content creation without thumbnail should work" do
    visit new_content_path

    fill_in "제목", with: "썸네일 없는 콘텐츠"
    fill_in "내용", with: "이 콘텐츠는 썸네일이 없습니다."
    select "비디오", from: "콘텐츠 유형"
    fill_in "태그", with: "테스트"

    # Do not attach any file
    click_button "콘텐츠 생성"

    # Verify the content was created successfully
    assert_text "Content was successfully created"
    
    content = Content.last
    assert_current_path content_path(content)
    
    # Verify the content appears
    assert_text "썸네일 없는 콘텐츠"
    
    # Verify no thumbnail is attached
    assert_not content.thumbnail.attached?
  end

  test "form validation should prevent submission with missing required fields" do
    visit new_content_path

    # Try to submit with missing title
    fill_in "내용", with: "내용만 있는 콘텐츠"
    click_button "콘텐츠 생성"

    # Should stay on the form page and show validation errors
    assert_current_path contents_path
    assert_text "can't be blank"
  end

  test "should display existing thumbnail when editing content" do
    # Create content with thumbnail
    content = Content.create!(
      title: "썸네일 있는 콘텐츠",
      body: "기존 썸네일을 가진 콘텐츠입니다.",
      content_type: "newsletter",
      user: @user
    )
    
    test_image_path = create_test_image
    content.thumbnail.attach(
      io: File.open(test_image_path),
      filename: "test_image.png",
      content_type: "image/png"
    )

    visit edit_content_path(content)

    # Should show current thumbnail preview
    assert_text "현재 썸네일:"
    assert_selector "img", count: 1 # Current thumbnail image

    # Clean up
    File.delete(test_image_path) if File.exist?(test_image_path)
  end

  private

  def create_test_image
    # Create a temporary PNG file for testing
    temp_dir = Rails.root.join("tmp", "test_images")
    FileUtils.mkdir_p(temp_dir)
    
    file_path = temp_dir.join("test_upload_#{SecureRandom.hex(8)}.png")
    
    # Create a minimal valid PNG image (1x1 pixel)
    png_data = [
      0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, # PNG signature
      0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52, # IHDR chunk header
      0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, # Width: 1, Height: 1
      0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, # Bit depth: 8, Color type: 6 (RGB + Alpha), etc.
      0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44, 0x41, # IDAT chunk header
      0x54, 0x78, 0x9C, 0x62, 0x00, 0x01, 0x00, 0x00, # Compressed image data
      0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, # More compressed data
      0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82 # IEND chunk
    ].pack('C*')
    
    File.binwrite(file_path, png_data)
    file_path.to_s
  end
end