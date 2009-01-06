class Iknow3gItem < ActiveRecord::Base
  has_many :progresses, :class_name => 'Iknow3gProgress', :foreign_key => 'iknow3g_item_id'
  
  def self.valid_hash?(hash)
    hash['cue']['text']
    hash['cue']['sound']
    hash['responses'][0]['quizzes'][0]['question']
    hash['responses'][0]['quizzes'][0]['answer']
    true
  rescue
    false
  end

  # TODO: it there some better ways to do this?
  def data=(hash); self[:data] = hash.to_json end
  def data; JSON.parse self[:data] end

  def text; data['cue']['text'] end
  def sound; data['cue']['sound'] end

  def translation; data['responses'][0]['quizzes'][0]['question'] end
  def word; data['responses'][0]['quizzes'][0]['answer'] end

  def distractors
    data['responses'][0]['quizzes'].find{|q| q['type'] == 'Multiple Choice'}['distractors']
  end

  def sentence; data['sentences'].first end
  def sentence_text; sentence['text'] end
  def sentence_sound; sentence['sound'] end
  #def sentence_text_image; sentence['image'] end
  #def sentence_translation; sentence['translations']['text'] end
  #def sentence_translation_sound; sentence['translations']['sound'] end
  #def sentence_translation_image; sentence['translations']['image'] end

  def generate_sentence_quiz
    words = sentence_text.split ' '
    answer_indices = []
    answers = []
    key_word = words.find{|w| w.index(key[0..-2]) == 0}
    indices = (0..(words.size-1)).to_a.shuffle
    if key_word
      key_index = words.index key_word
      answer_indices << key_index
      indices.delete key_index
      answer_indices << indices[0]
      answer_indices << indices[1]
    else
      answer_indices << indices[0]
      answer_indices << indices[1]
      answer_indices << indices[2]
    end
    answer_indices.compact.sort.each_with_index do |answer_index, index|
      answers << words[answer_index]
      words[answer_index] = "(#{index + 1})"
    end
    [words.join(' '), answers]
  end
end
