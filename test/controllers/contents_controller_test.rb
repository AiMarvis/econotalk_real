require "test_helper"

class ContentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(id: 1)
    @tag1 = Tag.create!(name: "경제")
    @tag2 = Tag.create!(name: "주식")
    @content = Content.create!(
      title: "Test Content",
      body: "Test body content",
      link: "https://example.com",
      content_type: "column",
      user: @user
    )
    @content.tags << [@tag1, @tag2]
  end

  test "should get index" do
    get contents_url
    assert_response :success
    assert_includes @response.body, "콘텐츠 관리"
    assert_includes @response.body, @content.title
  end

  test "should show content" do
    get content_url(@content)
    assert_response :success
    assert_includes @response.body, @content.title
    assert_includes @response.body, @content.body
    assert_includes @response.body, "경제"
    assert_includes @response.body, "주식"
  end

  test "should get new" do
    get new_content_url
    assert_response :success
    assert_includes @response.body, "새 콘텐츠 작성"
  end

  test "should create content" do
    assert_difference("Content.count") do
      post contents_url, params: { 
        content: { 
          title: "New Content", 
          body: "New body", 
          content_type: "video",
          user_id: @user.id
        } 
      }
    end

    assert_redirected_to content_url(Content.last)
    assert_equal "New Content", Content.last.title
  end

  test "should create content with tags" do
    assert_difference("Content.count") do
      assert_difference("Tag.count", 1) do # Only "부동산" is new
        post contents_url, params: { 
          content: { 
            title: "New Content with Tags", 
            body: "New body", 
            content_type: "newsletter",
            user_id: @user.id,
            tag_names: "경제, 주식, 부동산"
          } 
        }
      end
    end

    content = Content.last
    assert_redirected_to content_url(content)
    assert_equal 3, content.tags.count
    assert_includes content.tags.map(&:name), "경제"
    assert_includes content.tags.map(&:name), "주식"
    assert_includes content.tags.map(&:name), "부동산"
  end

  test "should not create content with invalid data" do
    assert_no_difference("Content.count") do
      post contents_url, params: { 
        content: { 
          title: "", # Invalid - title is required
          body: "New body", 
          content_type: "video",
          user_id: @user.id
        } 
      }
    end

    assert_response :unprocessable_entity
  end

  test "should get edit" do
    get edit_content_url(@content)
    assert_response :success
    assert_includes @response.body, "콘텐츠 수정"
    assert_includes @response.body, @content.title
  end

  test "should update content" do
    patch content_url(@content), params: { 
      content: { 
        title: "Updated Title", 
        body: "Updated body",
        content_type: "newsletter",
        user_id: @user.id
      } 
    }
    
    assert_redirected_to content_url(@content)
    @content.reload
    assert_equal "Updated Title", @content.title
    assert_equal "Updated body", @content.body
    assert_equal "newsletter", @content.content_type
  end

  test "should update content tags" do
    patch content_url(@content), params: { 
      content: { 
        title: @content.title, 
        body: @content.body,
        content_type: @content.content_type,
        user_id: @user.id,
        tag_names: "투자, 금융"
      } 
    }
    
    assert_redirected_to content_url(@content)
    @content.reload
    assert_equal 2, @content.tags.count
    assert_includes @content.tags.map(&:name), "투자"
    assert_includes @content.tags.map(&:name), "금융"
  end

  test "should not update content with invalid data" do
    patch content_url(@content), params: { 
      content: { 
        title: "", # Invalid
        body: @content.body,
        content_type: @content.content_type,
        user_id: @user.id
      } 
    }
    
    assert_response :unprocessable_entity
    @content.reload
    assert_not_equal "", @content.title # Title should remain unchanged
  end

  test "should destroy content" do
    assert_difference("Content.count", -1) do
      delete content_url(@content)
    end

    assert_redirected_to contents_url
  end

  test "tag creation with find_or_create_by" do
    # Test that existing tags are reused and new ones are created
    initial_tag_count = Tag.count
    
    post contents_url, params: { 
      content: { 
        title: "Tag Test Content", 
        body: "Test body", 
        content_type: "column",
        user_id: @user.id,
        tag_names: "경제, 새태그1, 새태그2"
      } 
    }
    
    content = Content.last
    assert_equal 3, content.tags.count
    assert_equal initial_tag_count + 2, Tag.count # Only 2 new tags created
    assert_includes content.tags.map(&:name), "경제" # Existing tag reused
    assert_includes content.tags.map(&:name), "새태그1"
    assert_includes content.tags.map(&:name), "새태그2"
  end

  test "empty and blank tag names are handled correctly" do
    post contents_url, params: { 
      content: { 
        title: "Empty Tag Test", 
        body: "Test body", 
        content_type: "column",
        user_id: @user.id,
        tag_names: "경제, , 주식, ,,"
      } 
    }
    
    content = Content.last
    assert_equal 2, content.tags.count # Only "경제" and "주식"
    assert_includes content.tags.map(&:name), "경제"
    assert_includes content.tags.map(&:name), "주식"
  end

  # Thumbnail upload tests
  test "should create content with thumbnail attachment" do
    image_file = fixture_file_upload("test_image.png", "image/png")
    
    assert_difference("Content.count") do
      post contents_url, params: { 
        content: { 
          title: "Content with Thumbnail", 
          body: "Test body with thumbnail", 
          content_type: "column",
          user_id: @user.id,
          thumbnail: image_file
        } 
      }
    end

    content = Content.last
    assert_redirected_to content_url(content)
    assert content.thumbnail.attached?
    assert_equal "image/png", content.thumbnail.content_type
  end

  test "should update content with thumbnail attachment" do
    image_file = fixture_file_upload("test_image.png", "image/png")
    
    patch content_url(@content), params: { 
      content: { 
        title: @content.title, 
        body: @content.body,
        content_type: @content.content_type,
        user_id: @user.id,
        thumbnail: image_file
      } 
    }
    
    assert_redirected_to content_url(@content)
    @content.reload
    assert @content.thumbnail.attached?
    assert_equal "image/png", @content.thumbnail.content_type
  end

  test "should create content without thumbnail attachment" do
    assert_difference("Content.count") do
      post contents_url, params: { 
        content: { 
          title: "Content without Thumbnail", 
          body: "Test body without thumbnail", 
          content_type: "video",
          user_id: @user.id
        } 
      }
    end

    content = Content.last
    assert_redirected_to content_url(content)
    assert_not content.thumbnail.attached?
  end

  test "should update content and replace existing thumbnail" do
    # First attach a thumbnail
    initial_image = fixture_file_upload("test_image.png", "image/png")
    @content.thumbnail.attach(initial_image)
    assert @content.thumbnail.attached?
    
    # Now update with a new thumbnail
    new_image = fixture_file_upload("test_image.png", "image/png")
    patch content_url(@content), params: { 
      content: { 
        title: @content.title, 
        body: @content.body,
        content_type: @content.content_type,
        user_id: @user.id,
        thumbnail: new_image
      } 
    }
    
    assert_redirected_to content_url(@content)
    @content.reload
    assert @content.thumbnail.attached?
    assert_equal "image/png", @content.thumbnail.content_type
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