class Bookmark < ApplicationRecord
    belongs_to :user, class_name: 'User' 
    belongs_to :tweet, class_name: 'Tweet'
end
