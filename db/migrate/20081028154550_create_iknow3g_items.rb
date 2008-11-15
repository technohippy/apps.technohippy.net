class CreateIknow3gItems < ActiveRecord::Migration
  def self.up
    create_table :iknow3g_items do |t|
      t.string :key
      t.text :data
      t.integer :num_of_question
      t.datetime :created_at

      t.timestamps
    end
  end

  def self.down
    drop_table :iknow3g_items
  end
end
