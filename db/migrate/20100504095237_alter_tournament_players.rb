class AlterTournamentPlayers < ActiveRecord::Migration
  def self.up
    execute %Q{ ALTER TABLE `tournament_players`
                DROP FOREIGN KEY `tournament_players_ibfk_4`}

    execute %Q{ ALTER TABLE `tournament_players` CHANGE COLUMN `level_id` `player_level_id` INT(11) UNSIGNED NOT NULL,
                DROP INDEX `level_id`,
                ADD INDEX `player_level_id` USING BTREE(`player_level_id`),
                ADD CONSTRAINT `tournament_players_ibfk_4` FOREIGN KEY `tournament_players_ibfk_4` (`player_level_id`) REFERENCES `player_levels` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
              }
  end

  def self.down
  end
end
