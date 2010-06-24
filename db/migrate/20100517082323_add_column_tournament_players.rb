class AddColumnTournamentPlayers < ActiveRecord::Migration
  def self.up
    execute %Q{  ALTER TABLE `tournament_players` ADD COLUMN `area_name` VARCHAR(50) AFTER `points` }
  end

  def self.down
  end
end
