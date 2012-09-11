SPECIAL_KEYS =
  backspace: 8
  tab:       9
  enter:     13
  shift:     16
  ctrl:      17
  alt:       18
  pause:     19
  capslock:  20
  esc:       27
  pageup:    33
  pagedown:  34
  end:       35
  home:      36
  left:      37
  up:        38
  right:     39
  down:      40
  insert:    45
  delete:    46
  multiply:  106
  plus:      107
  minus:     109
  divide:    111

Object.defineProperty KeyboardEvent::, 'key', get: ->
  for key, value of SPECIAL_KEYS
    if value is @keyCode
      return key
  String.fromCharCode(@keyCode).toLowerCase()