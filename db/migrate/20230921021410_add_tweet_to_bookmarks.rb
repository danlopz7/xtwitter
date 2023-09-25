class AddTweetToBookmarks < ActiveRecord::Migration[7.0]
  def change
    add_reference :bookmarks, :tweet, null: false, foreign_key: true
  end
end
