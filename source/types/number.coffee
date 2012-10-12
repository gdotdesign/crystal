Object.defineProperties Number::,
  # Date
  seconds:
    get: ->
      @valueOf() * 1e+3
  minutes:
    get: ->
      @valueOf() * 6e+4
  hours:
    get: ->
      @valueOf() * 3.6e+6
  days:
    get: ->
      @valueOf() * 8.64e+7
  # Iterators
  upto:
    value: (limit,func,bound = @) ->
      i = parseInt(@)
      while i <= limit
        func.call bound, i
        i++
  downto:
    value: (limit,func,bound = @) ->
      i = parseInt(@)
      while i >= limit
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
        max - Math.abs(val % max)
      else
        val