# @requires ./logger

window.ConsoleLogger = class Logging.ConsoleLogger extends Logging.Logger
constructor: -> super

['debug', 'error', 'fatal', 'info', 'warn','log'].forEach (type) ->
  ConsoleLogger::["_"+type] = (text) ->
    type = 'log' if type is 'debug'
    type = 'error' if type is 'fatal'
    console[type] text