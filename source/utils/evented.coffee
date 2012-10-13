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

window.Mediator = {
    events: {}
    listeners: {}
    fireEvent: (type,event)->
      if @listeners[type]
        for callback in @listeners[type]
          callback? event
    addListener: (type,callback) ->
      throw "Only functions can be added as callback" unless callback instanceof Function
      unless @listeners[type]
        @listeners[type] = []
      @listeners[type].push callback
    removeListener: (type, callback) ->
      @listeners[type].remove$ callback
      if @listeners[type].length is 0
        delete @listeners[type]
  }


window.Evented = class Evented
  toString: ->
    "[Object #{@__proto__.constructor.name}]"

  _ensureEvents: (type) ->
    @_events ?= {}
    @_events[type] ?= []

  trigger: (type,args...) ->
    event = new Event type, @
    args.push event
    @_ensureEvents(type)
    for callback in @_events[type]
      callback.apply @, args

  on: (type, callback) ->
    @_ensureEvents(type)
    @_events[type].push callback

  off: (type,callback) ->
    @_ensureEvents(type)
    if @_events[type].include callback
      @_events[type].remove callback
    if @_events[type].length is 0
      delete @_events[type]

  publish: (type,args...) ->
    event = new Event type, @
    args.unshift event
    Mediator.fireEvent type, args

  subscribe: (type,callback) ->
    Mediator.addListener callback

  unsubscribe: (type,callback) ->
    Mediator.removeListener type