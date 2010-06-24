class AddColumnAccountProfile < ActiveRecord::Migration
  def self.up
    add_column :account_profiles, :photo_file_name, :string
    add_column :account_profiles, :photo_content_type, :string
    add_column :account_profiles, :photo_file_size, :integer
  end
 
  def self.down
    remove_column :account_profiles, :photo_file_name
    remove_column :account_profiles, :photo_content_type
    remove_column :account_profiles, :photo_file_size
  end
end
