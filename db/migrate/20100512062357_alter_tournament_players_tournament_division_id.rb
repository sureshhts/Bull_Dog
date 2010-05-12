class AlterTournamentPlayersTournamentDivisionId < ActiveRecord::Migration
  def self.up
    execute %Q{ ALTER TABLE `tournament_players` DROP FOREIGN KEY `tournament_players_ibfk_3` }

    execute %Q{ ALTER TABLE `tournament_players` CHANGE COLUMN `division_id` `tournament_division_id` INT(11) UNSIGNED DEFAULT NULL, DROP INDEX `division_id`,
                ADD INDEX `tournament_division_id` USING BTREE(`tournament_division_id`),
                ADD CONSTRAINT `tournament_players_ibfk_3` FOREIGN KEY `tournament_players_ibfk_3` (`tournament_division_id`)
                REFERENCES `tournament_divisions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
              }
  end

  def self.down
  end
end
