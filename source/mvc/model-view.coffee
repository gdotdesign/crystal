window.ModelView = class ModelView
  constructor: (@model, @view)->
    @__bindings__ = []
    for key,args of @bindings
      args = [args] unless args instanceof Array
      [selector,binding] = key.split '|'
      if Bindings[binding]
        @__bindings__.push [selector.trim(), binding.trim(), args]
    for key,fn of @events
      @view.delegateEvent key, fn.bind @
  render: ->
    for bobj in @__bindings__
      [selector,binding,args] = bobj
      args = args.dup()
      views = if selector is '.' then @view else @view.all(selector)
      args.unshift views
      Bindings[binding].apply @model, args