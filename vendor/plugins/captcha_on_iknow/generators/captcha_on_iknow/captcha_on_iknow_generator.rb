class CaptchaOnIknowGenerator < Rails::Generator::NamedBase
  def initizlize(runtime_args, runtime_options={})
    super
  end

  def manifest
    record do |m|
      m.class_collisions 'CaptchaOnIknowController', 'IKnowCaptcha'

      m.directory 'app/controllers'
      m.directory 'app/models'
      m.directory 'app/views/captcha_on_iknow'
      m.directory 'public/images'
      m.directory 'public/javascripts'
      m.directory 'public/stylesheets'

      m.template 'i_know_captcha.rb', 'app/models/i_know_captcha.rb', :assigns => {:account => @name}
      m.file 'captcha_on_iknow_controller.rb', 'app/controllers/captcha_on_iknow_controller.rb'
      m.file '_sound.html.erb', 'app/views/captcha_on_iknow/_sound.html.erb'
      m.file '_text.html.erb', 'app/views/captcha_on_iknow/_text.html.erb'
      m.file 'reload.gif', 'public/images/reload.gif'
      m.file 'replay.gif', 'public/images/replay.gif'
      m.file 'type.gif', 'public/images/type.gif'
      m.file 'volume.gif', 'public/images/volume.gif'
      m.file 'captcha_on_iknow.js', 'public/javascripts/captcha_on_iknow.js'
      m.file 'captcha_on_iknow.css', 'public/stylesheets/captcha_on_iknow.css'
    end
  end
end

