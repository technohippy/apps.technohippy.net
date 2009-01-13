class Iknow3gController < ApplicationController
  include Iknow3gHelper
  layout 'iknow3g'

  before_filter :check_username, :except => ['settings', 'setup', 'check', 'checked', 'clear_username']

  def index
    @title = 'iKnow 3G!'
    @action_navi = {
      :url => url_for(:action => 'settings'),
      :label => 'Settings'
    }
  end

  def about_iknow3g
    @title = 'About iKnow 3G!'
    set_back_to_index
  end

  def about_author
    set_back_to_index
  end

  def check
    @javascripts = ['check_iknow_username']
  end

  def checked
    back, session[:back] = session[:back], nil
    if params[:username].blank? or not Iknow3gUser.exist? params[:username]
      redirect_to :action => 'settings'
    else
      session[:user] = Iknow3gUser.find_by_name params[:username]
      redirect_to back
    end
  end

  # TODO: temporary
  def clear_username
    session[:user] = nil 
    redirect_to :action => 'settings'
  end

  def settings
    @user = session[:user] || flash[:wrong_user] || Iknow3gUser.new
    @javascripts = ['iknow3g_settings']
    @action_navi = {
      :url => 'javascript:iknow3g.settings_ok()',
      :label => 'OK'
    }
    set_back_to_index if session[:user]
  end

  def setup
    @user = Iknow3gUser.find_by_name params[:user][:name]
    should_clear_current_exam = false
    if @user
      if session[:user] and session[:user] == @user
        @user.password = params[:user][:password]
      else
        @user.check_or_raise params[:user][:password]
      end
      should_clear_current_exam = (@user.current_exam and (@user.iknow_user != params[:user][:iknow_user]))
      @user.iknow_user = params[:user][:iknow_user]
    else
      @user = Iknow3gUser.new params[:user]
    end
    @user.save!
    @user.check_iknow_if_needed
    if should_clear_current_exam
      delete_exam @user.current_exam 
      @user.reload
    end
    cookies[:user_id] = @user.id.to_s
    session[:user] = @user
    redirect_to :action => 'index'
  rescue
    flash[:errors] =
      case $!
      when Iknow3gUser::PasswordUnmatchException
        'Username or password is incorrect'
      when Iknow3gApi::InvalidResultError
        'iKnow! User does not exist'
      else
        @user.errors
      end
    flash[:wrong_user] = Iknow3gUser.new params[:user]
    redirect_to :action => 'settings'
  end

  def learn
    set_back_to_index
    set_progress_bar
    @login_user.prepare_exam unless current_exam
    @login_user.reload
  end

  def exam
    set_back_to_index
    set_progress_bar
    @progress = @login_user.current_exam.learning_progresses.any rescue nil
    if @progress
      send @progress.next_quiz
      render :action => @progress.next_quiz
    else
      @login_user.current_exam.finish!
      redirect_to :action => 'complete'
    end
  end

  def meaning
    @javascripts = ['iknow3g_meaning']
  end

  def spelling
  end

  def word_in_sentence
    @question, @answer = @progress.item.generate_sentence_quiz
  end

  def answer
    set_back_to_index
    set_progress_bar
    @anwer = params[:answer]
    @progress = Iknow3gProgress.find params[:progress_id]
    lang = @progress.item.lang
    @success = normalize_word(params[:question], lang) == normalize_word(params[:answer], lang)
    @progress.progress! if @success
    method_name = "answer_#{params[:type]}"
    send method_name
    render :action => method_name
  end

  def answer_meaning
  end

  def answer_spelling
  end
  
  def answer_word_in_sentence
  end

  def complete
    @items = Iknow3gExam.find(params[:exam_id]).items
  end

  def clear
    case params[:target]
    when 'current'
      delete_exam @login_user.current_exam
    when 'all'
      @login_user.exams.each {|exam| delete_exam exam}
    end
    redirect_to :action => 'settings'
  end

  def show_item
    @item = Iknow3gItem.find params[:id]
    @title = @item.text.capitalize
    @back_navi = {
      :url => params[:back],
      :label => 'Back'
    }
  end

  protected

  def set_back_to_index
    @back_navi = {
      :url => url_for(:action => 'index'),
      :label => 'Top'
    }
  end

  def set_progress_bar
    @show_progress_bar = true
  end

  def check_username
    if session[:user].blank?
      if cookies[:user_id]
        session[:user] = Iknow3gUser.find cookies[:user_id]
        session[:user].check_iknow_if_needed
      else
        redirect_to :action => 'settings' and return false
      end
    end
    @login_user = session[:user]
    #if session[:user].blank?
    #  session[:back] = url_for
    #  redirect_to :action => 'check' and return false
    #end
    #@login_user = session[:user]
  end

  def normalize_word(word, lang='en')
    return '' if word.blank?
    #word.gsub(%r{</?spell>}, '').gsub(/[,.:;'"\\\-_〜]/, '').gsub(/\s+/, ' ').downcase.strip
    #word.downcase.gsub(%r{</?spell>}, '').gsub(/[^a-z]/, '')
    word = word.downcase.gsub(%r{</?spell>}, '')
    word = word.gsub(/[^a-z]/, '') unless ['ja', 'cn'].include? lang
    word
  end

  def delete_exam(exam)
    exam.items.each{|i| i.destroy}
    exam.progresses.each{|p| p.destroy}
    exam.destroy
  end
end
