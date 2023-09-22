class AddForeignKeysToFollows < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :follows, :users, column: :followee
    add_foreign_key :follows, :users, column: :follower
  end
end
