class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :contents, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_contents, through: :bookmarks, source: :content
  
  def bookmarked?(content)
    bookmarks.exists?(content: content)
  end
end
