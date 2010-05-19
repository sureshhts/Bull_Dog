class CreateScheduleTables < ActiveRecord::Migration
  def self.up
    execute %Q{ CREATE TABLE `tournament_division_league_schedules` (
                `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
                `week_number` INT(11) UNSIGNED NOT NULL,
                `start_date` INT(11) UNSIGNED,
                `end_date` INT(11) UNSIGNED,
                `tournament_division_id` INT(11) UNSIGNED,
                PRIMARY KEY (`id`),
                INDEX `Index_2` USING BTREE(`tournament_division_id`),
                CONSTRAINT `FK_tournament_division_league_schedules_1` FOREIGN KEY `FK_tournament_division_league_schedules_1` (`tournament_division_id`)
                REFERENCES `tournament_divisions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE ) ENGINE = InnoDB}

    execute %Q{ CREATE TABLE `league_schedule_games` (
                `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
                `tournament_division_league_schedule_id` INT(11) UNSIGNED,
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
                PRIMARY KEY (`id`),
                INDEX `Index_2` USING BTREE(`tournament_division_league_schedule_id`),
                INDEX `Index_3` USING BTREE(`winner`),
                INDEX `Index_4` USING BTREE(`loser`),
                CONSTRAINT `FK_league_schedule_games_1` FOREIGN KEY `FK_league_schedule_games_1` (`tournament_division_league_schedule_id`)
                  REFERENCES `tournament_division_league_schedules` (`id`)
                  ON DELETE CASCADE
                  ON UPDATE CASCADE,
                CONSTRAINT `FK_league_schedule_games_2` FOREIGN KEY `FK_league_schedule_games_2` (`winner`)
                  REFERENCES `tournament_players` (`id`)
                  ON DELETE CASCADE
                  ON UPDATE CASCADE,
                CONSTRAINT `FK_league_schedule_games_3` FOREIGN KEY `FK_league_schedule_games_3` (`loser`)
                  REFERENCES `tournament_players` (`id`)
                  ON DELETE CASCADE
                  ON UPDATE CASCADE
              )
              ENGINE = InnoDB
              }
    execute %Q{ CREATE TABLE `league_game_players` (
                `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
                `league_schedule_game_id` INT(11) UNSIGNED,
                `tournament_player_id` INT(11) UNSIGNED,
                PRIMARY KEY (`id`),
                INDEX `Index_2` USING BTREE(`league_schedule_game_id`),
                INDEX `Index_3` USING BTREE(`tournament_player_id`),
                CONSTRAINT `FK_league_game_players_1` FOREIGN KEY `FK_league_game_players_1` (`league_schedule_game_id`)
                  REFERENCES `league_schedule_games` (`id`)
                  ON DELETE CASCADE
                  ON UPDATE CASCADE,
                CONSTRAINT `FK_league_game_players_2` FOREIGN KEY `FK_league_game_players_2` (`tournament_player_id`)
                  REFERENCES `tournament_players` (`id`)
                  ON DELETE CASCADE
                  ON UPDATE CASCADE
              )
              ENGINE = InnoDB;
              }

    execute %Q{ drop table divisional_games }

    execute %Q{ drop table players_playoffs }
  end

  def self.down
  end
end
