class AddRoundsColumnToTournaments < ActiveRecord::Migration
  def self.up
    execute %Q{ ALTER TABLE `tournaments` ADD COLUMN `knockout_rounds` INT(11) UNSIGNED AFTER `knockout_created`}

    execute %Q{ ALTER TABLE `tournament_players` ADD COLUMN `knockout_rank` INT(11) UNSIGNED AFTER `knockout`}
  end

  def self.down
  end
end
