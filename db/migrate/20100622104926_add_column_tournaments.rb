class AddColumnTournaments < ActiveRecord::Migration
  def self.up
   add_column :tournaments, :tournament_ends, :integer
  end

  def self.down
   remove_column :tournaments, :tournament_ends
  end
end
