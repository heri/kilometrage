class AddIndex < ActiveRecord::Migration
  def change
    add_index :tracks, :rental_id
  end
end
