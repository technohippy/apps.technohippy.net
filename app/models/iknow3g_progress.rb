class Iknow3gProgress < ActiveRecord::Base
  belongs_to :exam, :class_name => 'Iknow3gExam', :foreign_key => 'iknow3g_exam_id'
  belongs_to :item, :class_name => 'Iknow3gItem', :foreign_key => 'iknow3g_item_id'
  acts_as_list :scope => :iknow3g_exam

  QUIZ_TYPES = [
    '',
    'meaning',
    'spelling',
    'word_in_sentence',
    #'sentence',
  ]
  MAX_NUM_OF_QUIZZES = QUIZ_TYPES.size - 1

  def next_quiz; QUIZ_TYPES[point + 1] end
  def num_of_quizzes 
    item.have_not_sentence? ? MAX_NUM_OF_QUIZZES - 1 : MAX_NUM_OF_QUIZZES
  end

  def progress!
    next_point = point + 1
    update_attribute :point, next_point
    update_attribute :finished_at, Time.now if num_of_quizzes <= next_point
    exam.finish! if exam.learning_progresses.empty?
  end

  def multiple_choices
    #distractors = (item.distractors || exam.items.map{|i| i.translation}).shuffle
    distractors = exam.items.shuffle
    choices = distractors.map{|d| {:label => d.translation, :value => d.word}}
    choices.last[:label] = '[上の選択肢にない]'
    choices
  end
end
