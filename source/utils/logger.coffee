define ['../types/array','../types/object'], ->
  class Logger
    @DEBUG: 4
    @INFO: 3
    @WARN: 2
    @ERROR: 1
    @FATAL: 0
    constructor: (level, object = console) ->
      object = console unless object.canRespondTo 'log', 'error', 'fatal', 'info', 'warn'
      @bound = object
      @_level = parseInt(level).clamp 0, 4
      @_timestamp = true
      
    _format: (arg) ->
      line = ""
      if @timestamp
        line += "["+date.format("%Y-%M-%D %H:%T")+"] "
      line += arg.toString()

    fatal: (args...) ->
      if @level <= Logger.FATAL
        @error "Fatal Error:"
        @error.apply @, args
    
    error: (args...) ->
      if @level >= Logger.INFO
        for arg in args
          @bound.error @_format arg
          if (stack = arg.stack)?
            @bound.error stack

  for type in ['debug','warn','info']
    Logger::[type] = (args...) ->
      if @level >= Logger[type.toUpperCase()]
        args.map (arg) =>
          @bound[type] @_format arg
        
  Object.defineProperties Logger::,
    timestamp: 
      set: (value) ->
        @_timestamp = !!value
      get: ->
        @_timestamp
    level:
      set: (value) -> 
        @_level = parseInt(value).clamp 0, 4
      get: ->
        @_level
        
  Logger
