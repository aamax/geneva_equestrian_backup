class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
    	t.string :name
      t.string :fname
      t.string :midinit
      t.string :lname
      t.string :email
      t.string :homephone
      t.string :cellphone
      t.string :street
      t.string :city
      t.string :state
      t.string :zip
      t.boolean :admin, :default => false
      t.string :encrypted_password
      t.string :salt

      t.timestamps
    end
  end
  
  def self.down
  	drop_table :users
  end
end
