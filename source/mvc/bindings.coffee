
window.Bindings = class Bindings
  @_wrap: (fn) ->
    (els,args...) ->
      els.forEach (el) =>
        args.unshift el
        fn.apply @, args
  @define: (key,value) ->
    if typeof key is 'string'
      @[key] = @_wrap value
    else
      @[key.name] = @_wrap key.render
      @["_"+key.name] = @_wrap key.initialize

# Default Bindings
Bindings.define 'text', (el,property) ->
  el.text = @[property]

Bindings.define 'visible', (el,property) ->
  el.css 'display', if @[property] then 'block' else 'none'

Bindings.define 'toggleClass', (el,property,cls) ->
  if @[property]
    el.classList.add cls
  else
    el.classList.remove cls

Bindings.define 
  name: 'value'
  render: (el,property) ->
    el.value = @[property]
  initialize: (el,property) ->
    el.addEvent 'input', =>
      @[property] = el.value
