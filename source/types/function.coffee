Object.defineProperties Function::,
  delay:
    value: (ms,bind = @,args...) ->
      id = setTimeout =>
        @apply bind, args
        clearTimeout id
      , ms
  periodical:
    value: (ms,bind = @, args...) ->
      setInterval =>
        @apply bind, args
      , ms

  property:
    value: (property,descriptor) ->
      descriptor.configurable = true
      Object.defineProperty @prototype, property, descriptor

  get: value: (property, fn) ->
    descriptor = Object.getOwnPropertyDescriptor @prototype, property
    if descriptor
      descriptor.get = fn
    else
      descriptor = {get:fn}
    @property property, descriptor

  set: value: (property, fn) ->
    descriptor = Object.getOwnPropertyDescriptor @prototype, property
    if descriptor
      descriptor.set = fn
    else
      descriptor = {set:fn}
    @property property, descriptor