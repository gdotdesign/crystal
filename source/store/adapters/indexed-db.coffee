# @requires ../store

window.Store.IndexedDB = class Store.IndexedDB
    init: (callback) ->
      @version = "1.0"
      @database = 'store'
      a = window
      a.indexedDB = a.indexedDB || a.webkitIndexedDB || a.mozIndexedDB
      request = window.indexedDB.open(@prefix)
      request.onsuccess = (e) =>
        @db = e.target.result
        unless @version is @db.version
          setVrequest = @db.setVersion(@version)
          setVrequest.onfailure = @error
          setVrequest.onsuccess = (e) =>
            store = @db.createObjectStore(@database, keyPath: "key")
            trans = setVrequest.result
            trans.oncomplete = ->
              callback @
        else
          callback @
      request.onfailure = @error
    
    get: (key, callback) ->
      trans = @db.transaction([@database], 'readwrite')
      store = trans.objectStore(@database)
      request = store.get key.toString()
      request.onerror = ->
        callback false
      request.onsuccess = (e) =>
        result = e.target.result
        if result
          callback @deserialize result.value
        else
          callback false

    set: (key, value, callback) ->
      trans = @db.transaction([@database], 'readwrite')
      store = trans.objectStore(@database)
      request = store.put(
        key: key.toString()
        value: @serialize value
      )
      request.onsuccess = ->
        callback true
      request.onerror = @error

    list: (callback) ->
      trans = @db.transaction([@database], 'readwrite')
      store = trans.objectStore(@database)
      cursorRequest = store.openCursor()
      cursorRequest.onerror = @error
      ret = []
      cursorRequest.onsuccess = (e) =>
        result = e.target.result
        if result 
          ret.push result.value.key
          result.continue()
        else
          callback ret

    remove: (key, callback) ->
      trans = @db.transaction([@database], 'readwrite')
      store = trans.objectStore(@database)  
      r = store.get key.toString()
      r.onerror = ->
        callback false
      r.onsuccess = (e) =>
        result = e.target.result
        if result
          r = store.delete key.toString() 
          r.onsuccess = -> 
            callback true
          r.onerror = ->
            callback false
        else
          callback false

