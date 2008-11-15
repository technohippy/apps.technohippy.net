class Iknow3gUser < ActiveRecord::Base
  class PasswordUnmatchException < StandardError; end

  validates_uniqueness_of :name
  has_many :exams, :class_name => 'Iknow3gExam', :foreign_key => 'user_id'
  has_one :last_exam, :class_name => 'Iknow3gExam', :foreign_key => 'user_id', :order => 'id DESC'
  has_one :current_exam, :class_name => 'Iknow3gExam', :foreign_key => 'user_id', :conditions => 'finished_at IS NULL', :order => 'id DESC'
  has_many :finished_exams, :class_name => 'Iknow3gExam', :foreign_key => 'user_id', :conditions => 'finished_at IS NOT NULL'

  attr_reader :profile, :results

  def self.exist?(username)
    self.find_by_name(params[:username])
  end

  def check_or_raise(password)
    if self.password == password
      true
    else
      raise PasswordUnmatchException
    end
  end

  def check_iknow_if_needed
    check_iknow if !profile or !current_exam
  end

  def check_iknow
    @profile = Iknow3gApi.user_profile self.iknow_user
    @results = {
      'iknow' => (Iknow3gApi.study_results(self.iknow_user, :iknow)['totals']['completed'] rescue 0),
      'dictation' => (Iknow3gApi.study_results(self.iknow_user, :dictation)['totals']['completed'] rescue 0)
    }
  rescue
    raise Iknow3gApi::InvalidResultError
  end

  def prepare_exam
    exams.create.construct
  end
end
