# @requires ../store

window.Store.WebSQL = class Store.WebSQL

    init: (callback) ->
      @exec = (statement, callback = (->), args) ->
        @db.transaction (tr) =>
          tr.executeSql statement, args, callback, (tr,err) =>
            callback false
          , ->
            callback false
      @db = openDatabase @prefix, '1.0', 'Store', 5 * 1024 * 1024
      @exec "CREATE TABLE IF NOT EXISTS store ( 'key' VARCHAR PRIMARY KEY NOT NULL, 'value' TEXT)", =>
        callback @

    get: (key, callback) ->
      @exec "SELECT * FROM store WHERE key = '#{key}'", (tr,result) =>
        if result.rows.length > 0
          ret = @deserialize result.rows.item(0).value
        else
          ret = false
        callback.call @, ret

    set: (key, value, callback) ->
      @exec "SELECT * FROM store WHERE key = '#{key}'", (tr,result) =>
        unless result.rows.length > 0
          @exec "INSERT INTO store (key, value) VALUES ('#{key}','#{@serialize value}')", (tr, result) =>
            if result.rowsAffected is 1
              callback true
            else
              callback false
        else
          @exec "UPDATE store SET value = '#{@serialize value}' WHERE key = '#{key}'", (tr, result) =>
            if result.rowsAffected is 1
              callback true
            else
              callback false

    list: (callback) ->
      @exec "SELECT key FROM store", (tr, results) =>
        keys = []
        if results.rows.length > 0
          [0..results.rows.length-1].forEach (i) ->
            keys.push results.rows.item(i).key
        callback keys

    remove: (key, callback) ->
      @exec "DELETE FROM store WHERE key = '#{key}'", (tr, result) =>
        if result.rowsAffected is 1
          callback true
        else
          callback false
