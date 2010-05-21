class AddDrawCreatedColumnToTournamentDivisions < ActiveRecord::Migration
  def self.up
    execute %Q{ ALTER TABLE `tournament_divisions` ADD COLUMN `draw_created` ENUM('1','0') NOT NULL DEFAULT '0' AFTER `area_name` }
  end

  def self.down
  end
end
