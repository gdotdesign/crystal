# @requires ../types/keyboard-event
window.Keyboard = class Keyboard
  handleKeydown: (e) =>
    delimeters = /-|\+|:|_/g
    unless e.cancelled
      combo = []
      combo.push "ctrl" if e.ctrlKey
      combo.push "shift" if e.shiftKey
      combo.push "alt" if e.altKey
      combo.push e.key
      for sc, method of @
        pressed = true
        for key in sc.split delimeters
          if combo.indexOf(key) is -1
            pressed = false
            break
        if pressed
          method.call @
          e.preventDefault()
          e.cancelled = true
          e.stopPropagation()
          break
  constructor: (@focus = false)->
    document.addEventListener 'keydown', (e) =>
      if @focus
        if document.first(":focus")
          @handleKeydown e
      else
        unless document.first(':focus')
          @handleKeydown e
    @initialize?()