define ->
  Object.defineProperties Number::,
    # Date
    seconds:
      get: ->
        @valueOf() * 1000
    minutes:
      get: ->
        @seconds * 60
    hours:
      get: ->
        @minutes * 60
    days:
      get: ->
        @hours * 24
    # Iterators
    upto:
      value: (limit,func,bound = @) ->
        i = parseInt(@)
        while i < limit
          func.call bound, i
          i++
    downto:
      value: (limit,func,bound = @) ->
        i = parseInt(@)
        while i > limit
          func.call bound, i
          i--
    times:
      value: (func,bound = @) ->
        for i in [1..parseInt(@)]
          func.call bound, i
    # Utility
    clamp:
      value: (min,max) ->
        min = parseFloat(min)
        max = parseFloat(max)
        val = @valueOf()
        if val > max 
          max
        else if val < min 
          min
        else
          val
    clampRange:
      value: (min,max) ->
        min = parseFloat(min)
        max = parseFloat(max)
        val = @valueOf()
        if val > max 
          val % max
        else if val < min 
          max + val % max
        else
          val
  Number
