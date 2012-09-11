# @requires ../types/keyboard-event
window.Keyboard = class Keyboard
  constructor: ->
    document.addEventListener 'keyup', (e) =>
      console.log e.keyCode
      e.preventDefault()
      combo = []
      combo.push "ctrl" if e.ctrlKey
      combo.push "shift" if e.shiftKey
      combo.push "alt" if e.altKey
      combo.push e.key
      for sc, method of @shortcuts
        pressed = true
        for key in sc.split "+"
          if combo.indexOf(key) is -1
            pressed = false
            break
        if pressed
          @[method].call @
          break
    @initialize?()