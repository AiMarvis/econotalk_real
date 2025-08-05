class Content < ApplicationRecord
  belongs_to :user
  has_many :content_tags, dependent: :destroy
  has_many :tags, through: :content_tags
  
  enum :content_type, { column: 0, video: 1, newsletter: 2 }
  
  validates :title, presence: true, length: { minimum: 1, maximum: 200 }
  validates :body, presence: true, length: { minimum: 1 }
  validates :content_type, presence: true
  validates :link, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), allow_blank: true }
end
