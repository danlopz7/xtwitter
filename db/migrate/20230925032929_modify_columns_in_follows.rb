class ModifyColumnsInFollows < ActiveRecord::Migration[7.0]
  def change
    remove_column :follows, :follower, :integer
    remove_column :follows, :followee, :integer

    # nuevas columnas de tipo referencia
    add_reference :follows, :follower, null: false, foreign_key: { to_table: :users }
    add_reference :follows, :followee, null: false, foreign_key: { to_table: :users }
  end
end
