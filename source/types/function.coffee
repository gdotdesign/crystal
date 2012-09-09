Object.defineProperties Function::,
  delay:
    value: (ms,bind = @,args...) ->
      id = setTimeout ms, ->
        clearTimeout id
        @apply bind, args
  periodical:
    value: (ms,bind = @, args...) ->
      setInterval ms, ->
        @apply bind, args