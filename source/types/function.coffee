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