class Reply < ApplicationRecord
    belongs_to :user
    belongs_to :tweet
    belongs_to :parent_reply, class_name: Reply, foreign_key: reply_id, optional: true
    has_many :replies, foreign_key: reply_id, dependent: :destroy
end
