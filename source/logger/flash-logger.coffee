# @requires ./logger
# @requires ../dom/element

window.FlashLogger = class Logging.FlashLogger extends Logging.Logger
  constructor: (el, level) ->
    throw "Base Element must be HTMLElement" unless el instanceof HTMLElement
    super level
    @visible = false
    @el = el
  hide: ->
    clearTimeout @id
    @id = setTimeout =>
      @visible = false
      @el.classList.toggle 'hidden'
      @el.classList.toggle 'visible'
    , 2000

['debug', 'error', 'fatal', 'info', 'warn','log'].forEach (type) ->
  FlashLogger::["_"+type] = (text) ->
    if @visible
      @el.html += "</br>"+text
      @hide()
    else
      @el.text = text
      @el.classList.toggle 'hidden'
      @el.classList.toggle 'visible'
      @visible = true
      @hide()
