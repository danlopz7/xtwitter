class Reply < ApplicationRecord
  belongs_to :user, class_name: 'User'
  belongs_to :tweet, class_name: 'Tweet'

  validates :content, presence: true, length: { maximum: 255 }
end
