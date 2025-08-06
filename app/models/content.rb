class Content < ApplicationRecord
  belongs_to :user
  has_many :content_tags, dependent: :destroy
  has_many :tags, through: :content_tags
  has_one_attached :thumbnail
  
  enum :content_type, { column: 0, video: 1, newsletter: 2 }
  
  # Content type helpers for views
  def self.content_type_options
    content_types.map do |key, _|
      [I18n.t("contents.content_types.#{key}"), key]
    end
  end
  
  def content_type_display_name
    I18n.t("contents.content_types.#{content_type}")
  end
  
  validates :title, presence: true, length: { minimum: 1, maximum: 200 }
  validates :body, presence: true, length: { minimum: 1 }
  validates :content_type, presence: true
  validates :link, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), allow_blank: true }
  
  # 뷰에서 사용할 메서드들
  def description
    body&.truncate(200) || ""
  end
  
  def author
    user&.name || user&.email || "Unknown Author"
  end
  
  def url
    link.present? ? link : Rails.application.routes.url_helpers.content_path(self)
  end
  
  def thumbnail_url
    thumbnail.attached? ? Rails.application.routes.url_helpers.rails_blob_path(thumbnail, only_path: true) : nil
  end
end
