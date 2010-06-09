class CreateKnockoutTables < ActiveRecord::Migration
  def self.up
    execute %Q{ CREATE TABLE `knockout_games` (
                `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
                `tournament_id` INT(11) UNSIGNED,
                `winner` INT(11) UNSIGNED,
                `loser` INT(11) UNSIGNED,
                `winner_set_1` INT(11) UNSIGNED,
                `winner_set_2` INT(11) UNSIGNED,
                `winner_set_3` INT(11) UNSIGNED,
                `loser_set_1` INT(11) UNSIGNED,
                `loser_set_2` INT(11) UNSIGNED,
                `loser_set_3` INT(11) UNSIGNED,
                `winner_score` INT(11) UNSIGNED,
                `loser_score` INT(11) UNSIGNED,
                `start_date` INT(11) UNSIGNED,
                `end_date` INT(11) UNSIGNED,
                `parent_game_id` INT(11) UNSIGNED,
                PRIMARY KEY (`id`),
                INDEX `Index_k2` USING BTREE(`tournament_id`),
                INDEX `Index_k3` USING BTREE(`winner`),
                INDEX `Index_k4` USING BTREE(`loser`),
                INDEX `Index_k5` USING BTREE(`parent_game_id`),
                CONSTRAINT `FK_knockout_games_1` FOREIGN KEY `FK_knockout_games_1` (`tournament_id`)
                  REFERENCES `tournaments` (`id`)
                  ON DELETE CASCADE
                  ON UPDATE CASCADE,
                CONSTRAINT `FK_knockout_games_2` FOREIGN KEY `FK_knockout_games_2` (`winner`)
                  REFERENCES `tournament_players` (`id`)
                  ON DELETE CASCADE
                  ON UPDATE CASCADE,
                CONSTRAINT `FK_knockout_games_3` FOREIGN KEY `FK_knockout_games_3` (`loser`)
                  REFERENCES `tournament_players` (`id`)
                  ON DELETE CASCADE
                  ON UPDATE CASCADE,
                CONSTRAINT `FK_knockout_games_4` FOREIGN KEY `FK_knockout_games_4` (`parent_game_id`)
                  REFERENCES `knockout_games` (`id`)
                  ON DELETE CASCADE
                  ON UPDATE CASCADE
              )
              ENGINE = InnoDB
              }
    execute %Q{ CREATE TABLE `knockout_game_players` (
                `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
                `knockout_game_id` INT(11) UNSIGNED,
                `tournament_player_id` INT(11) UNSIGNED,
                PRIMARY KEY (`id`),
                INDEX `Index_2` USING BTREE(`knockout_game_id`),
                INDEX `Index_3` USING BTREE(`tournament_player_id`),
                CONSTRAINT `FK_knockout_game_players_1` FOREIGN KEY `FK_knockout_game_players_1` (`knockout_game_id`)
                  REFERENCES `knockout_games` (`id`)
                  ON DELETE CASCADE
                  ON UPDATE CASCADE,
                CONSTRAINT `FK_knockout_game_players_2` FOREIGN KEY `FK_knockout_game_players_2` (`tournament_player_id`)
                  REFERENCES `tournament_players` (`id`)
                  ON DELETE CASCADE
                  ON UPDATE CASCADE
              )
              ENGINE = InnoDB
              }
    execute %Q{ ALTER TABLE `tournaments` ADD COLUMN `knockout_created` ENUM('1','0') NOT NULL DEFAULT 0 AFTER `knockout_selected`}

    execute %Q{ ALTER TABLE `knockout_games` ADD COLUMN `round` INT(11) UNSIGNED AFTER `parent_game_id`}
  end

  def self.down
  end
end
