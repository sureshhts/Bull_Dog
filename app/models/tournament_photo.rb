class TournamentPhoto < ActiveRecord::Base

has_attached_file :photo, 
     :styles => { :medium => "300x300>",
     :thumb => "50x50>"},
     :path => "c:\\ruby\\bulldog_dev\\Bull_Dog\\public\\photos\\drafts\\:id\\:style\\:basename.:extension",
     :url => "http://localhost:3000/photos/drafts/:id/:style/:basename.:extension"

end
