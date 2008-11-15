class AddHaveNotSentenceToIknow3gItem < ActiveRecord::Migration
  def self.up
    add_column :iknow3g_items, :have_not_sentence, :boolean
  end

  def self.down
    remove_column :iknow3g_items, :have_not_sentence
  end
end
