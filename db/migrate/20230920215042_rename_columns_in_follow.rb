class RenameColumnsInFollow < ActiveRecord::Migration[7.0]
  def change
    rename_column :follows, :follower, :follower_id
    rename_column :follows, :followee, :followee_id
  end
end
