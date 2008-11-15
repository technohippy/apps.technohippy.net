class CaptchaOnIknowController < ApplicationController
  before_filter :set_captcha

  def text
    @captcha.text_mode!
    render :partial => 'text'
  end

  def sound
    @captcha.sound_mode!
    render :partial => 'sound'
  end

  def reset
    @captcha.reset!
    render :partial => @captcha.spelling_mode? ? 'text' : 'sound'
  end

  protected

  def set_captcha
    @captcha = session[IKnowCaptcha.session_key]
  end
end
