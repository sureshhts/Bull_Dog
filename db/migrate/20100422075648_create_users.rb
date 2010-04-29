class CreateUsers < ActiveRecord::Migration
  def self.up
	  	
	execute %Q(
    CREATE TABLE users(
		id INT(11) UNSIGNED  NOT NULL AUTO_INCREMENT,
		time_created INT(11) UNSIGNED  NOT NULL,
		deleted enum('Yes','No') NOT NULL default 'No',
		login varchar(50) default NULL,
		name varchar(50) default NULL,
		email varchar(50) default NULL,
		account_type varchar(50) NOT NULL,
		salt varchar(50) default NULL,
		remember_token varchar(50) default NULL,
		remember_token_expires_at datetime default NULL,
		crypted_password varchar(255) default NULL,
		PRIMARY KEY  (id)
		) ENGINE=InnoDB;
	)
    
  end

  def self.down
    drop_table "users"
  end
end
