class Content < ApplicationRecord
  belongs_to :user
  has_many :content_tags, dependent: :destroy
  has_many :tags, through: :content_tags
  
  enum content_type: { column: 0, video: 1, newsletter: 2 }
end
