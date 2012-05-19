define ->
  #TODO
  #proerties base, vw, vh
  #converters toEm, toPt, toVw, toVH, toPx
  class Unit
    @UNITS: {'px': 0,  em: 1,    pt: 2}
    @TABLE: [1,     16,      16/12]
    constructor: (value = "0px") ->
      @set value

    toString: (type = "px") ->
      return @_value+"px" unless type of Unit.UNITS
      Math.round(@_value / Unit.TABLE[Unit.UNITS[type]]*100)/100+type
      
    set: (value) ->
      if(m = value.match /(\d+)(\w{2,5})$/)
        v = parseInt(m[1]) or 0
        factor = Unit.TABLE[Unit.UNITS[m[2]]]
        throw 'Wrong Unit format!' if isNaN(v) or factor is undefined
      else
        v = 0
        factor = 0
      @_value = v * factor
      
  ['px','em','pt'].forEach (type) ->
    Object.defineProperty Unit::, type,
      get: ->
        @toString(type)
  
  Unit
