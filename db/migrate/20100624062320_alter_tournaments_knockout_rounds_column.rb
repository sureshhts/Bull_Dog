class AlterTournamentsKnockoutRoundsColumn < ActiveRecord::Migration
  def self.up
    execute %Q{ ALTER TABLE `tournaments` CHANGE COLUMN `knockout_rounds` `knock_out_rounds` INT(11) UNSIGNED }
  end

  def self.down
  end
end
