# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100607115201) do

  create_table "account_playing_details", :force => true do |t|
    t.integer "user_id",                                        :null => false
    t.integer "facility_id",                                    :null => false
    t.integer "player_level_id",                                :null => false
    t.string  "verified",        :limit => 0, :default => "No", :null => false
  end

  add_index "account_playing_details", ["facility_id"], :name => "facility_id"
  add_index "account_playing_details", ["player_level_id"], :name => "player_level_id"
  add_index "account_playing_details", ["user_id"], :name => "user_id"

  create_table "account_profiles", :force => true do |t|
    t.string  "first_name",     :limit => 30,                  :null => false
    t.string  "last_name",      :limit => 30
    t.string  "gender",         :limit => 0,  :default => "m", :null => false
    t.string  "address1",       :limit => 50,                  :null => false
    t.string  "address2",       :limit => 50
    t.string  "city",           :limit => 30,                  :null => false
    t.string  "state",          :limit => 30,                  :null => false
    t.string  "zipcode",        :limit => 10,                  :null => false
    t.string  "contact_number", :limit => 15,                  :null => false
    t.string  "email_address",  :limit => 50,                  :null => false
    t.integer "user_id",                                       :null => false
  end

  add_index "account_profiles", ["user_id"], :name => "user_id"

  create_table "area_names", :force => true do |t|
    t.string "area_name", :limit => 50
    t.string "pincode",   :limit => 50
  end

  create_table "divisional_games", :force => true do |t|
    t.integer "tournament_division_id", :null => false
    t.integer "week_number",            :null => false
    t.integer "starts",                 :null => false
    t.integer "ends",                   :null => false
    t.integer "player1_set1"
    t.integer "player1_set2"
    t.integer "player1_set3"
    t.integer "player2_set1"
    t.integer "player2_set2"
    t.integer "player2_set3"
  end

  add_index "divisional_games", ["tournament_division_id"], :name => "tournament_division_id"

  create_table "facilities", :force => true do |t|
    t.string "name",     :limit => 50, :null => false
    t.string "address1", :limit => 50, :null => false
    t.string "address2", :limit => 50
    t.string "city",     :limit => 30, :null => false
    t.string "state",    :limit => 30, :null => false
    t.string "zipcode",  :limit => 10, :null => false
  end

  create_table "facilities_tournament_divisions", :force => true do |t|
    t.integer "tournament_division_id", :null => false
    t.integer "facility_id",            :null => false
  end

  add_index "facilities_tournament_divisions", ["facility_id"], :name => "facility_id"
  add_index "facilities_tournament_divisions", ["tournament_division_id"], :name => "tournament_division_id"

  create_table "knockout_game_players", :force => true do |t|
    t.integer "knockout_game_id"
    t.integer "tournament_player_id"
  end

  add_index "knockout_game_players", ["knockout_game_id"], :name => "Index_2"
  add_index "knockout_game_players", ["tournament_player_id"], :name => "Index_3"

  create_table "knockout_games", :force => true do |t|
    t.integer "tournament_id"
    t.integer "winner"
    t.integer "loser"
    t.integer "winner_set_1"
    t.integer "winner_set_2"
    t.integer "winner_set_3"
    t.integer "loser_set_1"
    t.integer "loser_set_2"
    t.integer "loser_set_3"
    t.integer "winner_score"
    t.integer "loser_score"
    t.integer "start_date"
    t.integer "end_date"
    t.integer "parent_game_id"
  end

  add_index "knockout_games", ["loser"], :name => "Index_k4"
  add_index "knockout_games", ["parent_game_id"], :name => "Index_k5"
  add_index "knockout_games", ["tournament_id"], :name => "Index_k2"
  add_index "knockout_games", ["winner"], :name => "Index_k3"

  create_table "league_game_players", :force => true do |t|
    t.integer "league_schedule_game_id"
    t.integer "tournament_player_id"
  end

  add_index "league_game_players", ["league_schedule_game_id"], :name => "Index_2"
  add_index "league_game_players", ["tournament_player_id"], :name => "Index_3"

  create_table "league_schedule_games", :force => true do |t|
    t.integer "tournament_division_league_schedule_id"
    t.integer "winner"
    t.integer "loser"
    t.integer "winner_set_1"
    t.integer "winner_set_2"
    t.integer "winner_set_3"
    t.integer "loser_set_1"
    t.integer "loser_set_2"
    t.integer "loser_set_3"
    t.integer "winner_score"
    t.integer "loser_score"
  end

  add_index "league_schedule_games", ["loser"], :name => "Index_4"
  add_index "league_schedule_games", ["tournament_division_league_schedule_id"], :name => "Index_2"
  add_index "league_schedule_games", ["winner"], :name => "Index_3"

  create_table "player_levels", :force => true do |t|
    t.string "name", :limit => 50, :null => false
  end

  create_table "players_playoffs", :force => true do |t|
    t.integer "tournament_player_id",                               :null => false
    t.integer "opponent"
    t.integer "divisional_game_id"
    t.string  "game_status",          :limit => 0, :default => "0", :null => false
    t.integer "game_date",                                          :null => false
    t.integer "points",                                             :null => false
  end

  add_index "players_playoffs", ["divisional_game_id"], :name => "divisional_game_id"
  add_index "players_playoffs", ["opponent"], :name => "opponent"
  add_index "players_playoffs", ["tournament_player_id"], :name => "tournament_player_id"

  create_table "tournament_categories", :force => true do |t|
    t.string "name", :limit => 50, :null => false
  end

  create_table "tournament_category_mappings", :force => true do |t|
    t.integer "tournament_category_id", :null => false
    t.integer "tournament_id"
  end

  add_index "tournament_category_mappings", ["tournament_category_id"], :name => "tournament_category_id"
  add_index "tournament_category_mappings", ["tournament_id"], :name => "tournament_id"

  create_table "tournament_division_league_schedules", :force => true do |t|
    t.integer "week_number",            :null => false
    t.integer "start_date"
    t.integer "end_date"
    t.integer "tournament_division_id"
  end

  add_index "tournament_division_league_schedules", ["tournament_division_id"], :name => "Index_2"

  create_table "tournament_divisions", :force => true do |t|
    t.string  "name",                   :limit => 50,                  :null => false
    t.integer "tournament_id",                                         :null => false
    t.integer "no_of_players"
    t.integer "tournament_category_id"
    t.integer "player_level_id"
    t.string  "area_name",              :limit => 50
    t.string  "draw_created",           :limit => 0,  :default => "0", :null => false
  end

  add_index "tournament_divisions", ["player_level_id"], :name => "Index_player_level_id"
  add_index "tournament_divisions", ["tournament_category_id"], :name => "Index_tournament_category_id"
  add_index "tournament_divisions", ["tournament_id"], :name => "tournament_id"

  create_table "tournament_players", :force => true do |t|
    t.integer "user_id",                                             :null => false
    t.integer "tournament_id",                                       :null => false
    t.integer "tournament_division_id"
    t.integer "player_level_id",                                     :null => false
    t.integer "tournament_category_id",                              :null => false
    t.integer "points",                               :default => 0
    t.string  "area_name",              :limit => 50
    t.string  "knockout",               :limit => 0
  end

  add_index "tournament_players", ["player_level_id"], :name => "player_level_id"
  add_index "tournament_players", ["tournament_category_id"], :name => "tournament_category_id"
  add_index "tournament_players", ["tournament_division_id"], :name => "tournament_division_id"
  add_index "tournament_players", ["tournament_id"], :name => "tournament_id"
  add_index "tournament_players", ["user_id"], :name => "user_id"

  create_table "tournaments", :force => true do |t|
    t.string  "name",                       :limit => 50,                  :null => false
    t.string  "city",                       :limit => 50,                  :null => false
    t.string  "tournament_type",            :limit => 0,  :default => "L", :null => false
    t.string  "kind_of_tournament",         :limit => 0,  :default => "O", :null => false
    t.integer "registration_starts",                                       :null => false
    t.integer "registration_ends",                                         :null => false
    t.integer "tournament_starts",                                         :null => false
    t.integer "knockout_cutoff_percentage"
    t.integer "knockout_count"
    t.string  "knockout_selected",          :limit => 0
  end

  create_table "users", :force => true do |t|
    t.integer  "time_created",                                              :null => false
    t.string   "deleted",                   :limit => 0,  :default => "No", :null => false
    t.string   "login",                     :limit => 50
    t.string   "name",                      :limit => 50
    t.string   "email",                     :limit => 50
    t.string   "account_type",              :limit => 50,                   :null => false
    t.string   "salt",                      :limit => 50
    t.string   "remember_token",            :limit => 50
    t.datetime "remember_token_expires_at"
    t.string   "crypted_password"
  end

end
