# @requires ../store

window.Store.FileSystem = class Store.FileSystem

  init: (callback) ->
    rfs = window.RequestFileSystem || window.webkitRequestFileSystem
    rfs window.PRESISTENT, 50*1024*1024, (store) =>
      @storage = store
      callback @
    , @error

  list: (callback) ->
    dirReader = @storage.root.createReader()
    entries = []
    readEntries = =>
      dirReader.readEntries (results) ->
        if (!results.length)
          entries.sort()
          callback entries.map (item) ->
            item.name
        else 
          entries = entries.concat(Array::slice.call(results))
          readEntries()
      , @error
    readEntries()

  remove: (file, callback) ->
    @storage.root.getFile file, null, (fe) =>
      fe.remove ->
        callback true
      , ->
        callback false
    , ->
      callback false

  get: (file, callback) ->
    @storage.root.getFile file, null, (fe) =>
      fe.file (f) =>
        reader = new FileReader()
        reader.onloadend = (e) =>
          callback @deserialize e.target.result
        reader.readAsText f
      , ->
        callback false
    , ->
      callback false

  set: (file, data, callback = ->) ->
    @storage.root.getFile file, {create:true}, (fe) =>
      fe.createWriter (fileWriter) =>
        fileWriter.onwriteend = (e) =>
          callback true
        fileWriter.onerror = (e) =>
          callback false
        bb = new (window.WebKitBlobBuilder || BlobBuilder())
        bb.append(@serialize data)
        fileWriter.write(bb.getBlob('text/plain'))
      , ->
        callback false
    , ->
      callback false
