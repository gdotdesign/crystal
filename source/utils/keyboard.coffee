# @requires ../types/keyboard-event
window.Keyboard = class Keyboard
  constructor: ->
    document.addEventListener 'keydown', (e) =>
      unless document.first(':focus')
        combo = []
        combo.push "ctrl" if e.ctrlKey
        combo.push "shift" if e.shiftKey
        combo.push "alt" if e.altKey
        combo.push e.key
        for sc, method of @
          pressed = true
          for key in sc.split "+"
            if combo.indexOf(key) is -1
              pressed = false
              break
          if pressed
            method.call @
            e.preventDefault()
            break
    @initialize?()