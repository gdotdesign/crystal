# @requires ../store

window.Store.LocalStorage = class Store.LocalStorage

  init: (callback) ->
    @prefix += "::" unless @prefix is ""
    callback @

  get: (key, callback) ->
    try
      ret = @deserialize localStorage.getItem @prefix+key.toString()
    catch error
      @error error
    callback ret or false

  set: (key, value, callback) ->
    try
      localStorage.setItem @prefix+key.toString(), @serialize value
      ret = true 
    catch error
      @error error
    callback ret or false

  list: (callback) ->
    ret = []
    for i in [0..localStorage.length-1]
      try
        key = localStorage.key(i)
        if @prefix != ""
          if new RegExp("^#{@prefix}").test key
            ret.push key.replace new RegExp("^#{@prefix}"), ""
        else
          ret.push key
      catch error
        @error error
    callback ret

  remove: (key, callback) ->
    if localStorage.getItem(@prefix+key) is null
      callback false 
      return
    try
      localStorage.removeItem @prefix+key.toString()
      ret = true
    catch error
      @error error
    callback ret or false