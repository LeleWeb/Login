class AddStatusToUsers < ActiveRecord::Migration
  def change
  	change_table :users do |t|
      t.integer :status,:default => 0,:null => false
    end
  end
end
