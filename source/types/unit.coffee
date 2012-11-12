window.Unit = class Unit
  @UNITS: {px: true,  em: true}
  constructor: (value = "0px", basePX = 16) ->
    @base = basePX
    @set value

  toString: (type = "px") ->
    return @_value+"px" unless type of Unit.UNITS
    if type is 'em'
      (@_value / @base)+"em"
    else
      return @_value+"px"

  set: (value) ->
    if(match = value.match /(\d+)(px|em)$/)
      [m,value,type] = match
      v = parseFloat(value) or 0
      if type is 'em'
        @_value = parseInt(@base*v)
      else
        @_value = parseInt(v)
    else
      throw 'Wrong Unit format!'

  @get 'px', -> @toString('px')
  @get 'em', -> @toString('em')
