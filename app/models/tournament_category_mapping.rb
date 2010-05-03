class TournamentCategoryMapping < ActiveRecord::Base
  belongs_to :tournament
  belongs_to :tournament_category

end