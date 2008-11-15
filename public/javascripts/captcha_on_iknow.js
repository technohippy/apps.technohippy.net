var iknow_captcha = $H();
iknow_captcha.handle_choice_text = function(selected) {
  $$('li.iknow-captcha-selected').each(function(item){
    item.className = 'iknow-captcha-choice';
  });
  $(selected).className = 'iknow-captcha-selected';
  $(IKNOW_CAPTCHA_PARAM_KEY).value = $(selected).innerHTML;
};

iknow_captcha.replay = function(url) {
  var embed = document.createElement('embed');
  embed.setAttribute('src', url);
  embed.setAttribute('hidden', true);
  embed.setAttribute('autostart', true);
  document.body.appendChild(embed);
  setTimeout(function(){document.body.removeChild(embed)}, 15000);
};
