class AddKnockoutCutoffColumsToTournaments < ActiveRecord::Migration
  def self.up
    execute %Q{ ALTER TABLE `tournaments` ADD COLUMN `knockout_cutoff_percentage` INT(11) UNSIGNED AFTER `tournament_starts`,
                ADD COLUMN `knockout_count` INT(11) UNSIGNED AFTER `knockout_cutoff_percentage`
              }

    execute %Q{ ALTER TABLE `tournament_players` ADD COLUMN `knockout` ENUM('1','0') AFTER `area_name`}

    execute %Q{ ALTER TABLE `tournaments` ADD COLUMN `knockout_selected` ENUM('1','0') AFTER `knockout_count` }

  end

  def self.down
  end
end
