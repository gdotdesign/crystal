Crystal.Utils.Event = class Utils.Event
  constructor: (target) ->
    throw "No target" unless !!target
    throw "Invalid target!" unless target instanceof Object
    @cancelled = false
    @target = target
  stop: ->
    @cancelled = true

class Utils.Mediator
  constructor: ->
    @listeners = {}
  fireEvent: (type,args)->
    event = args.first
    throw "Not Utils.Event!" unless event instanceof Utils.Event
    if @listeners[type]
      for callback in @listeners[type]
        unless event.cancelled
          callback.apply event.target, args
  addListener: (type,callback) ->
    throw "Only functions can be added as callback" unless callback instanceof Function
    @listeners[type] = [] unless @listeners[type]
    @listeners[type].push callback
  removeListener: (type, callback) ->
    @listeners[type].remove$ callback
    delete @listeners[type] if @listeners[type].length is 0

window.Mediator = new Utils.Mediator

Crystal.Utils.Evented = class Utils.Evented
  constructor: ->

  _ensureMediator: ->
    unless @_mediator
      Object.defineProperty @, "_mediator", value: new Utils.Mediator

  toString: ->
    "[Object #{@__proto__.constructor.name}]"

  trigger: (type,args...) ->
    event = new Utils.Event @
    args.unshift event
    @_ensureMediator()
    @_mediator.fireEvent type, args

  on: (type, callback) ->
    @_ensureMediator()
    @_mediator.addListener type, callback

  off: (type,callback) ->
    @_ensureMediator()
    @_mediator.removeListener type, callback

  publish: (type,args...) ->
    event = new Utils.Event @
    args.unshift event
    Mediator.fireEvent type, args

  subscribe: (type,callback) ->
    Mediator.addListener type, callback

  unsubscribe: (type,callback) ->
    Mediator.removeListener type, callback