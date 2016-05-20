class CreateUsers < ActiveRecord::Migration
  def change
  	create_table :users do |u|
      u.string :email
      u.string :password
      u.string :name
      u.text   :description
  	end
  end
end
