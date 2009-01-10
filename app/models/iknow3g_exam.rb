class Iknow3gExam < ActiveRecord::Base
  NUM_OF_CANDIDATE_ITEMS = 50
  NUM_OF_ITEMS = 8

  belongs_to :user, :class_name => 'Iknow3gUser', :foreign_key => 'user_id'
  has_many :progresses, :class_name => 'Iknow3gProgress', :foreign_key => 'iknow3g_exam_id'
  has_many :items, :through => :progresses

  def construct
    studied_items = Iknow3gApi.items_studied(user.iknow_user, :per_page => NUM_OF_CANDIDATE_ITEMS)
    #random_items = studied_items.shuffle
    random_items = studied_items.select{|item| Iknow3gItem.valid_hash? item}.shuffle # TODO:
    random_items[0..(NUM_OF_ITEMS-1)].each_with_index do |item, index|
      if item['sentences'].nil? or item['sentences'].empty?
        item['sentences'] = Iknow3gApi.search_sentences URI.escape(item['cue']['text'])
      end
      item_record = Iknow3gItem.create :key => item['cue']['text'], :data => item, :have_not_sentence => item['sentences'].empty?
      #self.progresses << Iknow3gProgress.create(:item => item_record, :point => 0)
      Iknow3gProgress.create :exam => self, :item => item_record, :point => 0, :position => index
    end
  end
  
  def learning_progresses
    progresses.find(:all, :conditions => 'finished_at IS NULL')
  end

  def learning_items
    learning_progresses.map{|p| p.item}
  end

  def finished_items
    progresses.find(:all, :conditions => 'finished_at IS NOT NULL').map{|p| p.item}
  end

  def finish!
    update_attribute :finished_at, Time.now
  end

  def finished?
    finished_at
  end
end
