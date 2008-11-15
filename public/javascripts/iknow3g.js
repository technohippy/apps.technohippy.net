var iknow3g = $H();
iknow3g.debug = false;

iknow3g.setupDB = function(dbname) {
  if (!dbname) dbname = 'iknow3g_v2';
  if (!window.openDatabase) return false;

  iknow3g.db = openDatabase(dbname);
  iknow3g.db.transaction(function(tx) {
    tx.executeSql(
      'SELECT * FROM settings', [],
      function(tx, rs) {},
      function(error) {
        tx.executeSql(
          'CREATE TABLE settings (id INTEGER PRIMARY KEY, name TEXT, password TEXT, iknow_user TEXT)', [],
          function(tx, rs) {},
          function(error) {if (iknow3g.debug) alert('Database Creation Error: ' + error.message)}
        );
      }
    );
  });
};
Event.observe(window, 'load', function() {iknow3g.setupDB()});

iknow3g.storeUser = function(name, password, iknowUser) {
  iknow3g.setupDB();
  if (!iknow3g.db) return;

  iknow3g.db.transaction(function(tx) {
    tx.executeSql(
      'INSERT INTO settings (name, password, iknow_user) VALUES (?, ?, ?)', [name, password, iknowUser],
      function(tx, rs) {},
      function(error) {if (iknow3g.debug) alert('Data Insertion Error: ' + error.message)}
    );
  });
};

iknow3g.loadUser = function(callback) {
  iknow3g.setupDB();
  if (!iknow3g.db) return null;

  iknow3g.db.transaction(function(tx) {
    tx.executeSql(
      'SELECT * from settings order by id DESC', [],
      function(tx, rs) {callback(rs.rows.item(0))},
      function(error) {}
    );
  });
};

iknow3g.clickClear = function(field, defaultText) {
  if (field.value == defaultText) {
    field.value = '';
  }
};

iknow3g.clickRecall = function(field, defaultText) {
  if (field.value == "") {
    field.value = defaultText;
  }
};

// for PC (not for iPhone)
iknow3g.replay = function(url) {
  var embed = document.createElement('embed');
  embed.setAttribute('src', url);
  embed.setAttribute('hidden', true);
  embed.setAttribute('autostart', true);
  document.body.appendChild(embed);
  setTimeout(function(){document.body.removeChild(embed)}, 15000);
};
