module Iknow3gHelper
  def title_or_action_name
    @title || controller.action_name.titleize
  end

  def text_iphone_field(model, field, label)
    text_field model, field,
      :onclick => "javascript:iknow3g.clickClear(this, '#{label}')",
      :onblur => "javascript:iknow3g.clickRecall(this, '#{label}')"
  end

  def text_iphone_field_tag(name, label)
    text_field_tag name, label,
      :onclick => "javascript:iknow3g.clickClear(this, '#{label}')",
      :onblur => "javascript:iknow3g.clickRecall(this, '#{label}')"
  end

  def user_image_tag(user)
    image_name = (user.profile['icon_url'] || '').split('/').last
    image_tag "http://www.iknow.co.jp/assets/users/#{image_name}", 
      :alt => user.profile['name'], :size => '54x54'
  end

  def current_exam
    @login_user.current_exam
  end

  def last_exam
    @login_user.last_exam
  end

  def current_items
    current_exam.items
  end

  def iphone?
    request.env['HTTP_USER_AGENT'] =~ /iPhone/
  end

  def safari?
    request.env['HTTP_USER_AGENT'] =~ /Safari/
  end

  def replay_button(sound_url, size='40x30')
    if iphone?
      width, height = size.split('x')
      option = ''
      option += "width='#{width}' " unless width.blank?
      option += "height='#{height}'" unless height.blank?
      "<embed src='#{sound_url}' #{option} autostart='true'></embed>"
    else
      "<button onclick=\"javascript:iknow3g.replay('#{sound_url}')\">Play</button>"
    end
  end

  def progress_bar(exam, class_name='')
    ret = "<table class='progress-bar #{class_name}'>"
    Iknow3gProgress::MAX_NUM_OF_QUIZZES.times do |rpoint|
      point = Iknow3gProgress::MAX_NUM_OF_QUIZZES - rpoint
      ret += '<tr>'
      exam.progresses.each do |progress|
        ret += '<td class="'
        ret +=
          if progress.num_of_quizzes < point; 'blank'
          elsif progress.point < point;       'not-yet'
          else;                               'done' end
        ret += '"></td>'
      end
      ret += '</tr>'
    end
    ret += '</table>'
    ret
  end

  def progress_percentage(exam)
    return 0 unless exam

    max, point = 0.0, 0.0
    exam.progresses.each do |progress|
      max += progress.num_of_quizzes
      point += progress.point
    end
    max == 0.0 ? 0 : (point / max * 100).ceil
  end
end
