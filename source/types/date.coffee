# @require ./number
Date.Locale = 
  ago:
    seconds: " seconds ago"
    minutes: " minutes ago"
    hours: " hours ago"
    days: " days ago"
    now: "just now"
  format: "%Y-%M-%D"

Object.defineProperties Date::,
  ago:
    get: ->
      diff = +new Date()-@
      console.log diff/(1).minutes
      if diff < (1).seconds
        Date.Locale.ago.now
      else if diff < (1).minutes
        Math.round(diff/1000)+Date.Locale.ago.seconds
      else if diff < (1).hours
        Math.round(diff/(1).minutes)+Date.Locale.ago.minutes
      else if diff < (1).days
        Math.round(diff/(1).hours)+Date.Locale.ago.hours
      else if diff < (30).days
        Math.round(diff/(1).days)+Date.Locale.ago.days
      else
        @format Date.Locale.format

  # TODO localization
  format:
    value: (str = Date.Locale.format) ->
      str.replace /%([a-zA-z])/g, ($0,$1) =>
        switch $1
          # Day
          when 'D'
            @getDate().toString().replace /^\d$/, "0$&"
          when 'd'
            @getDate()
          # Year
          when 'Y'
            @getFullYear()
          # Hours
          when 'h'
            @getHours()
          when 'H'
            @getHours().toString().replace /^\d$/, "0$&"
          # Month
          when 'M'
            (@getMonth()+1).toString().replace /^\d$/, "0$&"
          when 'm'
            @getMonth()+1
          # Minutes
          when "T"
            @getMinutes().toString().replace /^\d$/, "0$&"
          when "t"
            @getMinutes()
          else
            ""

['day:Date','year:FullYear','hours:Hours','minutes:Minutes','seconds:Seconds'].forEach (item) ->
  [prop,meth] = item.split(/:/)
  Object.defineProperty Date::, prop,
    get: ->
      @["get"+meth]()
    set: (value)->
      @["set"+meth] parseInt(value)


Object.defineProperty Date::, 'month',
  get: -> @getMonth()+1
  set: (value) -> @setMonth value-1