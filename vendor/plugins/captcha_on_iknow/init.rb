require 'open-uri'
require 'json'

class ActionView::Base
  def captcha_on_iknow_js_tag
    <<-eos
<script>IKNOW_CAPTCHA_PARAM_KEY = '#{IKnowCaptcha.param_key}'</script>
#{javascript_include_tag 'captcha_on_iknow'}
    eos
  end

  def iknow_captcha_field
    captcha = (controller.session[IKnowCaptcha.session_key] ||= IKnowCaptcha.new).reset!
    # Depend on mode and mode_changeable
    action =
      case captcha.mode.to_sym
      when :spellings; 'text'
      when :sentences; 'sound'
      else; raise IKnowCaptcha::InvaidModeError.new(captcha.mode)
      end
    url_params = {:controller => 'captcha_on_iknow', :action => action,
      :session_id => controller.session.session_id,
      :mode_changeable => captcha.mode_changeable,
      :authenticity_token => form_authenticity_token}
    <<-eos
      <div id="captcha"></div>
      <script>
        Event.observe(window, 'load', function(e) {
          new Ajax.Updater('captcha', '#{url_for url_params}');
        });
      </script>
    eos
  end
end

class ActionController::Base
  class <<self
    def iknow_captcha_check(*args)
      before_filter :iknow_captcha_check_filter, *args
    end
  end

  def iknow_captcha_pass?
    if (answer = params[IKnowCaptcha.param_key]) and
      (captcha = session[IKnowCaptcha.session_key])
      captcha.pass? answer
    else
      nil
    end
  end

  protected

  def iknow_captcha_check_filter
    unless iknow_captcha_pass?
      redirect_to :back
      return false
    end
  end
end
