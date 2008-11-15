class IKnowCaptcha
  class InvaidModeError < StandardError; end
  class FixedModeError < StandardError; end

  DEFAULT_USER = '<%= account %>'
  USER_PATTERN = '[USER]'
  API_KEY = '' # set your API key, if you want
  API_URI_TEMPLATE = "http://api.iknow.co.jp/users/#{USER_PATTERN}/items.json?api_key=#{API_KEY}"
  @session_key = :IKNOW_CHAPTCHA
  @param_key = :iknow_captcha_answer
  class <<self; attr_accessor :session_key, :param_key end

  attr_accessor :mode, :mode_changeable, :answer, :choices

  def initialize(opts={})
    options = {:user => DEFAULT_USER, :mode => :spellings, :mode_changeable => true}.update opts
    @user, @mode, @mode_changeable = options[:user], options[:mode], options[:mode_changeable]
    setup
  end

  def setup(user=@user)
    json = JSON.parse open(api_uri_for(user)){|f| f.read}
    setup_spellings json
    setup_sentences json
    reset!
  end

  def reset!(mode=@mode)
    raise FixedModeError.new(mode) if !@mode_changable and mode != @mode
    data = shuffle(instance_variable_get("@#{mode}"))[0..3]
    @choices = shuffle data.map{|e| e.last}
    @answer = data.first
    self
  end

  def spelling_mode!
    @mode = :spellings
    reset!
  end
  alias text_mode! spelling_mode!

  def spelling_mode?; @mode == :spellings end
  alias text_mode? spelling_mode?

  def sentence_mode!
    @mode = :sentences
    reset!
  end
  alias sound_mode! sentence_mode!

  def sentence_mode?; @mode == :sentences end
  alias sound_mode? sentence_mode?


  def question
    @answer.first
  end

  def pass?(answer)
    @answer.last == answer
  end

  def to_s
    <<-eos.gsub(/^    \| /, '')
    | Q, What does `#{@answer.first}' mean in English?
    |    Chose from: #{@choices.join ', '}
    | A. #{@answer.last}
    eos
  end

  def inspect
    "SPELLINGS: #{@spellings.inspect}\nSENTENCES: #{@sentences.inspect
      }\nCHOICES: #{@choices.inspect}\nANSWER: #{@answer.inspect}"
  end

  protected

  def setup_spellings(json)
    @spellings = {}
    each_data json, 'responses' do |responses|
      each_data responses, 'quizzes' do |quizzes|
        quizzes.select{|quiz| quiz['type'] == 'Spelling'}.each do |quiz|
          @spellings[quiz['question']] = quiz['answer']
        end
      end
    end
  end

  def setup_sentences(json)
    @sentences = {}
    each_data json, 'sentences' do |sentences|
      sentences.each do |sentence|
        @sentences[sentence['sound']] = sentence['text']
      end
    end
  end

  def api_uri_for(user)
    API_URI_TEMPLATE.sub USER_PATTERN, user
  end

  def each_data(list, key, &block)
    list.each {|data| block.call data[key]}
  end

  def shuffle(array)
    array.to_a.sort{|a, b| rand(3) - 1}
  end
end
