iknow3g.loadSetting = function() {
  if (!iknow3g.db) return;

  var setting = null;
  iknow3g.db.transaction(function(tx) {
    tx.executeSql(
      'SELECT * FROM settings', [],
      function(tx, rs) {
        if (0 < rs.rows.length) {
          setting = rs.rows.item(0);
        }
      },
      function(error) {}
    );
  });
  return setting;
};
Event.observe(window, 'load', function() {
  var username = '';
  var setting = iknow3g.loadSetting();
  if (setting) username = setting.username;
  window.location = '/iknow3g/checked?username=' + username;
});
