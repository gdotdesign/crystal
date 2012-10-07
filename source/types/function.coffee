Object.defineProperties Function::,
  delay:
    value: (ms,bind = @,args...) ->
      id = setTimeout =>
        clearTimeout id
        @apply bind, args
      , ms
  periodical:
    value: (ms,bind = @, args...) ->
      setInterval =>
        @apply bind, args
      , ms