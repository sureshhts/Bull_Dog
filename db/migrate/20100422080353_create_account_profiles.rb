class CreateAccountProfiles < ActiveRecord::Migration
  def self.up
  	execute %Q(
    CREATE TABLE account_profiles (
	id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	first_name varchar(30) not null,
	last_name varchar(30) default null,
	gender enum('m', 'f') NOT NULL default 'm',
	address1 varchar(50) not NULL,
	address2 varchar(50) default NULL,
	city varchar(30) not null,
	state varchar(30) not null,
	zipcode varchar(10) not null,
	contact_number varchar(15) not null,
	email_address varchar(50) not null,
	user_id int(11) UNSIGNED  NOT Null,
	PRIMARY KEY (id),
	Foreign key(user_id) references users(id) on delete cascade on update cascade
	) ENGINE=InnoDB;
  )
  end

  def self.down
    drop_table :account_profiles
  end
end
