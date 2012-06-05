define ->
  Object.defineProperty Date::, 'format', value: (str) ->
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
  Date
