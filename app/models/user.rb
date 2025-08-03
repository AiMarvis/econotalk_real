class User < ApplicationRecord
  has_many :contents, dependent: :destroy
end
