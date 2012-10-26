window.Model = class Model extends Crystal.Utils.Evented
  constructor: (data)->
    @_ensureProperties()
    for key,descriptor of @properties
      @_property key, descriptor
    for key,value of data
      if Object.getOwnPropertyDescriptor(@,key)
        @[key] = value

  _ensureProperties: ->
    unless @__properties__
      Object.defineProperty @, '__properties__',
        value: {}
        enumerable: false

  _property: (name, value)->
    Object.defineProperty @, name,
      get: ->
        @__properties__[name]
      set: (val) ->
        if value instanceof Function
          val = value val
        if val isnt @__properties__[name]
          @__properties__[name] = val
          @trigger 'change'
          @trigger 'change:'+name
      enumerable: true