define ->
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

  class Evented

    publish: (type,args...) ->
      @trigger.apply @, Array::slice arguments
      event = new Event type, @
      args.push event
      Mediator.fireEvent type, args

    trigger: (type,args...) ->
      @ensureEvents()
      event = new Event type, @
      args.push event
      if @__events__[type]
        for callback in @__events__[type]
          callback.apply @, args

    ensureEvents: ->
      unless @__events__
        Object.defineProperty @, '__events__', value: {}

    on: (type, callback, bind) ->
      @ensureEvents()
      @__events__[type] ?= []
      callback = callback.bind bind if bind
      @__events__[type].push callback

    off: (type,callback) ->
      @ensureEvents()
      if @__events__[type]
        if @__events__[type].include callback
          @__events__[type].remove callback

    subscribe: (type,callback) ->
      unless Mediator.events[type]
        Mediator.addListener type, (event) ->
          for cb in Mediator.events[event.type]
            break if event.cancelled
            cb event
          event.destroy()
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
