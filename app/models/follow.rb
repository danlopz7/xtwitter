class Follow < ApplicationRecord
    belongs_to :follower, class_name: 'User'
    belongs_to :followee, class_name: 'User'

    # para una relación belongs_to llamada follower, Rails asumirá que la clave foránea es 
    #"follower_id" en lugar de requerir que lo especifique explícitamente.
    # Rails asume convenciones por defecto para las claves foráneas

    # Validations
    validates :follower_id, uniqueness: { scope: :followee_id }

    # Association Validations
    validates_associated :follower, :followee
end
 
