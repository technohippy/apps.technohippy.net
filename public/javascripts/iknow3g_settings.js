iknow3g.settings_ok = function() {
  var name = $('user_name').value;
  var password = $('user_password').value;
  var iknowUser = $('user_iknow_user').value;
  iknow3g.storeUser(name, password, iknowUser);
  $('user_form').submit();
};

Event.observe(window, 'load', function() {
  $$('input').each(function(field) {if (field.onblur) field.onblur()});

  var name = $('user_name').value;
  var password = $('user_password').value;
  var iknowUser = $('user_iknow_user').value;
  if (name == 'Name' && password == 'Password' && iknowUser == 'iKnow! User') {
    iknow3g.loadUser(function(user) {
      $('user_name').value = user.name;
      $('user_password').value = user.password;
      $('user_iknow_user').value = user.iknow_user;
      $('user_form').submit();
    });
  }
});
