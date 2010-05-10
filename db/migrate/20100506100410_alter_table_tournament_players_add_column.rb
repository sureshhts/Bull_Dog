class AlterTableTournamentPlayersAddColumn < ActiveRecord::Migration
  def self.up
    execute %Q{ ALTER TABLE `tournament_players` ADD COLUMN `points` INT(11) UNSIGNED AFTER `category_id`}
  end

  def self.down
  end
end
