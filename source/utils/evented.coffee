Mediator = {
    events: {}
    listeners: {}
    fireEvent: (type,event)->
      if @listeners[type]
        @listeners[type].apply @, event
    addListener: (type,callback) ->
      @listeners[type] = callback
    removeListener: (type) ->
      delete @listeners[type]
  }

class Event
  constructor: (type,target) ->
    @cancelled = false
    @target = target
    @type = type
  destroy: ->
    for key, value of @
      @[key] = null
  stop: ->
    @cancelled = true

window.Evented = class Evented
  toString: ->
    "[#{@__proto__.constructor.name}]"
  addProperty: (name,value,enumerable = false) ->
    @__properties__ ?= []
    @__properties__[name] = value unless value instanceof Function
    Object.defineProperty @, name,
      get: ->
        @__properties__[name]
      set: (val) ->
        @__properties__[name] = val
        if value instanceof Function
          value val
        @trigger 'change'
        @trigger 'change:'+name
        if @_publish
          clearTimeout @_id if @_id
          @_id = setTimeout =>
            @publish 'action'
          , 300
      enumerable: !!enumerable
  publish: (type,args...) ->
    event = new Event type, @
    args.unshift event
    Mediator.fireEvent type, args

  trigger: (type,args...) ->
    @_events ?= {}
    event = new Event type, @
    args.push event
    if @_events[type]
      for callback in @_events[type]
        callback.apply @, args
    event.destroy()

  on: (type, callback) ->
    @_events ?= {}
    @_events[type] ?= []
    @_events[type].push callback

  off: (type,callback) ->
    @_events ?= {}
    if @_events[type]
      if @_events[type].include callback
        @_events[type].remove callback
    if @_events[type].length is 0
      delete Mediator.events[type]

  subscribe: (type,callback) ->
    unless Mediator.events[type]
      Mediator.addListener type, (event) ->
        for cb in Mediator.events[event.type]
          break if event.cancelled
          cb.apply @, Array::slice.call(arguments)
      Mediator.events[type] = []
    Mediator.events[type].push callback

  unsubscribe: (type,callback) ->
    if Mediator.events[type] is undefined
      console.error "No channel '#{type}' exists"
      return false
    if Mediator.events[type].include callback
      Mediator.events[type].remove callback
    if Mediator.events[type].length is 0
      delete Mediator.events[type]
      Mediator.removeListener type