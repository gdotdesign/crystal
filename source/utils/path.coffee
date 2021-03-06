window.Path = class Utils.Path
  constructor: (@context = {}) ->

  create: (path,value) ->
    path = path.toString()
    last = @context
    prop = (path = path.split(/\./)).pop()
    for segment in path
      if not last.hasOwnProperty(segment)
        last[segment] = {}
      last = last[segment]
    last[prop] = value

  exists: (path) ->
    @lookup(path) isnt undefined

  lookup: (path) ->
    end = (path = path.split(/\./)).pop()
    if path.length is 0 and not @context.hasOwnProperty(end) then return undefined
    last = @context
    for segment in path
      if last.hasOwnProperty(segment) then last = last[segment] else return undefined
    if last.hasOwnProperty(end) then return last[end]
    undefined
