# @requires ../types/array
# @requires ../types/object
# @requires ../types/number
# @requires ../types/date

get = (props,obj) -> obj::__defineGetter__ name, getter for name, getter of props
set = (props,obj) -> obj::__defineSetter__ name, setter for name, setter of props

window.Logger = class Logging.Logger
  @DEBUG: 4
  @INFO: 3
  @WARN: 2
  @ERROR: 1
  @FATAL: 0

  get {timestamp: ->
    @_timestamp
  }, @
  set {timestamp: (value)->
    @_timestamp = !!value
  }, @

  get {level: ->
    @_level
  }, @
  set {level: (value)->
    @_level = parseInt(value).clamp 0, 4
  }, @

  constructor: (level = 4) ->
    throw "Level must be Number" if isNaN parseInt(level)
    @_level = parseInt(level).clamp 0, 4
    @_timestamp = true

  _format: (args...) ->
    line = ""
    if @timestamp
      line += "["+new Date().format("%Y-%M-%D %H:%T")+"] "
    line += args.map((arg) -> args.toString()).join ","

['debug', 'error', 'fatal', 'info', 'warn'].forEach (type) ->
  Logger::["_"+type] = ->
  Logger::[type] = (args...) ->
    if @level >= Logger[type.toUpperCase()]
      @["_"+type] @_format args