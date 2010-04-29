class CreateFacilities < ActiveRecord::Migration
  def self.up
    execute %Q(
    create table facilities(
	id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	name varchar(50) not null,
	address1 varchar(50) not NULL,
	address2 varchar(50) default NULL,
	city varchar(30) not null,
	state varchar(30) not null,
	zipcode varchar(10) not null,
	primary key(id)
	)Engine = InnoDB;
  )
  end

  def self.down
    drop_table :facilities
  end
end
