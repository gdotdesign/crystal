window.Store = class Store.Store
  constructor: (options = {})->
    
    @prefix = options.prefix or ""
    ad = parseInt(options.adapter) or 0
    
    @$serialize = options.serialize if options.serialize instanceof Function
    @$deserialize = options.deserialize if options.deserialize instanceof Function
    
    a = window
    indexedDB = 'indexedDB' of a or 'webkitIndexedDB' of a or 'mozIndexedDB' of a
    requestFileSystem = 'requestFileSystem' of a or 'webkitRequestFileSystem' of a
    websql = 'openDatabase' of a
    localStore = 'localStorage' of a
    xhr = 'XMLHttpRequest' of a
    
    adapter = switch ad
      when 0
        if indexedDB
          Store.IndexedDB
        else if openDatabase
          Store.WebSQL
        else if requestFileSystem
          Store.FileSystem
        else if xhr
          Store.Request
        else if localStorage
          Store.LocalStorage
        else
          Store.Memory
      when 1
        throw "IndexedDB not supported!" unless indexedDB
        Store.IndexedDB
      when 2
        throw "WebSQL not supported!" unless openDatabase
        Store.WebSQL
      when 3
        throw "FileSystem not supported!" unless requestFileSystem
        Store.FileSystem
      when 4
        throw "LocalStorage not supported!" unless localStorage
        Store.LocalStorage
      when 5
        throw "XHR not supported!" unless xhr
        Store.Request
      when 6
        Store.Memory
      else
        throw "Adapter not found!"
    
    ['get','set','remove','list'].forEach (item) =>
        @[item] = ->
          args = Array::slice.call arguments
          if @running
            @chain item, args
          else
            @call item, args
          @
    
    @$chain = []
    
    @adapter = new adapter()
    
    @adapter.init.call @, (store) =>
      @ready = true
      options.callback? @
      @callChain()
  
  error: ->
    console.error arguments
  
  serialize: (obj) -> 
    if @$serialize
      return @$serialize obj
    JSON.stringify obj
  deserialize: (json) ->
    if @$deserialize
      return @$deserialize obj
    JSON.parse json 
  
  chain: (type, args) ->
    @$chain.push [type, args]
  callChain: ->
    if @$chain.length > 0
      first = @$chain.shift()
      @call first[0], first[1]
      
  call: (type, args) ->
    unless @ready
      @chain type, args
    else
      @running = true
      if (type is 'set' and args.length is 3) or (type is 'list' and args.length is 1) or ((type is 'get' or type is 'remove') and args.length is 2)
        callback = args.pop()
      @adapter[type].apply @, args.concat (data) =>
        if typeof callback is 'function' then callback data
        @running = false
        @callChain()

  @ADAPTER_BEST = 0
  @INDEXED_DB = 1
  @WEB_SQL = 2
  @FILE_SYSTEM = 3
  @LOCAL_STORAGE = 4
  @XHR = 5
  @MEMORY = 6