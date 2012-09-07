# @requires ./logger

class Crystal.ConsoleLogger extends Crystal.Logger
constructor: -> super

['debug', 'error', 'fatal', 'info', 'warn'].forEach (type) ->
  Crystal.ConsoleLogger::["_"+type] = (text) ->
    type = 'log' if type is 'debug'
    type = 'error' if type is 'fatal'
    console[type] text