define ->
  class Path
    constructor: (@context = {}) ->

    # path.create 'social.facebook.title', 'asd'
    create: (path,value) ->
      path = path.toString()
      last = @context
      end = (path = path.split(/\./)).pop()
      if path isnt ""
        path = path.split /\./
        prop = path.pop()
        for segment in path
          if not last.hasOwnProperty(segment)
            last[segment] = {}
          last = last[segment]
      last.prop = value

    # path.exstist 'social.facebook.title' -> true / false
    exstist: (path) ->
      @lookup(path) isnt undefined

    # path.lookup 'social.facebook.title' -> 'asd'
    lookup: (path) ->
      end = (path = path.split(/\./)).pop()
      if path.length is 0 and not  @context.hasOwnProperty(end) then return false
      last = @context
      for segment in path
        if last.hasOwnProperty(segment) then last = last[segment] else return undefined
      if last.hasOwnProperty(end) then return last[end]
      undefined
