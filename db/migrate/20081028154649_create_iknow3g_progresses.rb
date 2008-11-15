class CreateIknow3gProgresses < ActiveRecord::Migration
  def self.up
    create_table :iknow3g_progresses do |t|
      t.integer :iknow3g_item_id
      t.integer :iknow3g_exam_id
      t.integer :point
      t.integer :position
      t.datetime :finished_at

      t.timestamps
    end
  end

  def self.down
    drop_table :iknow3g_progresses
  end
end
