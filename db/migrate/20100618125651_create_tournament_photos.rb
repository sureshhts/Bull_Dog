class CreateTournamentPhotos < ActiveRecord::Migration
  def self.up
     create_table :tournament_photos do |t|
      t.integer :tournament_id
      t.string :photo_file_name
      t.string :photo_content_type
      t.integer :photo_file_size
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :tournament_photos
  end
end
