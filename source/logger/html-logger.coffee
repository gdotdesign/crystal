# @requires ./logger
# @requires ../dom/element

css =
  error:
    color: 'orangered'
  info:
    color: 'blue'
  warn:
    color: 'orange'
  fatal:
    color: 'red'
    'font-weight': 'bold'
  debug:
    color: 'black'
  log:
    color: 'black'

window.HTMLLogger = class Logging.HTMLLogger extends Logging.Logger
  constructor: (el, level) ->
    throw "Base Element must be HTMLElement" unless el instanceof HTMLElement
    super level
    @el = el

['debug', 'error', 'fatal', 'info', 'warn','log'].forEach (type) ->
  HTMLLogger::["_"+type] = (text) ->
    el = Element.create 'div.'+type
    for prop, value of css[type]
      el.css prop, value
    el.text = text
    @el.append el
    el