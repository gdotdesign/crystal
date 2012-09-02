# @requires ./logger
class ConsoleLogger extends Logger
constructor: -> super

['debug', 'error', 'fatal', 'info', 'warn'].forEach (type) ->
  ConsoleLogger::["_"+type] = (text) ->
    type = 'log' if type is 'debug'
    type = 'error' if type is 'fatal'
    console[type] text