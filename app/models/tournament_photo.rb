class TournamentPhoto < ActiveRecord::Base

has_attached_file :photo, 
     :styles => { :medium => "300x300>",
     :thumb => "50x50>"},
     :path => "http:\\tennis.hibiscustech.com\\images\\photos\\drafts\\:id\\:style\\:basename.:extension",
     :url => "http://tennis.hibiscustech.com/images/photos/drafts/:id/:style/:basename.:extension"

end
