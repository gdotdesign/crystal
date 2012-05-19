define ->
  class Path 
    create: (path, context = window)->
      last = context
      if path isnt ""
        path = path.split /\./
        for segment in path
          if last?
            if not last.hasOwnProperty(segment)
              last[segment] = {}
            last = last[segment]
          else
            if context.hasOwnProperty(segment)
              last = context[segment] = {}
      last
    
    exstist: (path, context = window) ->
      end = (path = path.split(/\./)).pop()
      if path.length is 0 and not context.hasOwnProperty(end) then return false
      last = context
      for segment in path
        if last.hasOwnProperty(segment) then last = last[segment] else return false
      if last[end] is undefined then return false
      true
      
    lookup: (path, context = window) ->
      end = (path = path.split(/\./)).pop()
      if path.length is 0 and not context.hasOwnProperty(end) then return false
      last = context
      for segment in path
        if last.hasOwnProperty(segment) then last = last[segment] else return undefined
      if last.hasOwnProperty(end) then return last[end]
      undefined
