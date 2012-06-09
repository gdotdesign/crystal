define ['./logger','../dom/element'], (Logger) ->
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
    debig:
      color: 'black'

  class HTMLLogger extends Logger
    constructor: (el, level) ->
      throw "Base Element must be HTMLElement" unless el instanceof HTMLElement
      super level
      @el = el

  ['debug', 'error', 'fatal', 'info', 'warn'].forEach (type) ->
    HTMLLogger::["_"+type] = (text) ->  
      el = Element.create 'div.'+type
      for prop, value of css[type]
        el.css prop, value
      el.text = text
      @el.append el
      el

  HTMLLogger