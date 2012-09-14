# @requires ../store

window.Store.Memory = class Store.Memory
  init: (callback) ->
    @store = {}
    callback? @

  get: (key, callback) -> 
    if (a = @store[key.toString()])
      ret = @deserialize a
    else
      ret = false
    callback? ret 

  set: (key, value, callback) ->
    try
      @store[key.toString()] = @serialize value
      ret = true 
    catch error
      @error error
    callback? ret or false

  list: (callback) ->
    ret = []
    try
      ret = for own key of @store 
        key
    catch error
      @error error
    callback? ret

  remove: (key, callback) ->
    if @store[key.toString()] is undefined
      callback false 
      return
    try
      delete @store[key.toString()]
      ret = true
    catch error
      @error error
    callback? ret or false
