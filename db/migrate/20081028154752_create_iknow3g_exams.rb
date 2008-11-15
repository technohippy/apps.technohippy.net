class CreateIknow3gExams < ActiveRecord::Migration
  def self.up
    create_table :iknow3g_exams do |t|
      t.integer :user_id
      t.datetime :started_at
      t.datetime :finished_at

      t.timestamps
    end
  end

  def self.down
    drop_table :iknow3g_exams
  end
end
