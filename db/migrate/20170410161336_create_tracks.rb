class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.integer :rental_id
      t.timestamps null: false
    end
    add_attachment :tracks, :recording

  end
end
