window.ModelView = class ModelView
  constructor: (@model, @view)->
    @__bindings__ = []
    for key,args of @bindings
      args = [args] unless args instanceof Array
      [selector,binding] = key.split '|'
      if (fn = Bindings[binding])
        if (fninit = Bindings["_"+binding])
          @apply fninit, selector.trim(), args
        @__bindings__.push [selector.trim(), binding.trim(), args, fn]
    for key,fn of @events
      @view.delegateEvent key, fn.bind @

  apply: (fn,selector,args) ->
    args = args.dup()
    views = if selector is '.' then [@view] else @view.all(selector)
    args.unshift views
    fn.apply @model, args
    
  render: ->
    for bobj in @__bindings__
      [selector,binding,args,fn] = bobj
      @apply fn, selector, args