class CreateIknow3gUsers < ActiveRecord::Migration
  def self.up
    create_table :iknow3g_users do |t|
      t.string :name
      t.string :password
      t.string :iknow_user

      t.timestamps
    end
  end

  def self.down
    drop_table :iknow3g_users
  end
end
