class Follow < ApplicationRecord
  # Relación para el usuario que sigue a otro usuario
  belongs_to :follower, class_name: 'User'

  # Relación para el usuario seguido por otro usuario
  belongs_to :followee, class_name: 'User'

  validates :followee_id, :follower_id, uniqueness: true
end
