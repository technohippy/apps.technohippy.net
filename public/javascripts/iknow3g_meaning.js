iknow3g.choose_answer = function(elm, val) {
  $$('ul#answers li').each(function(e) {
    e.className = '';
  });
  elm.className = 'selected';
  $('answer').value = val;
};
