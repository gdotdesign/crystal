window.Bindings =
  define: (key,value) ->
    @[key] = value
Bindings.define 'text', (els,property) ->
  els.forEach (el) => el.text = @[property]
Bindings.define 'toggleClass', (el,property,cls) ->
  if @[property]
    el.classList.add cls
  else
    el.classList.remove cls
Bindings.define 'value', (els,property) ->
  els.forEach (el) =>
    el.value = @[property]
    el.addEvent 'input', =>
      @[property] = el.value

Bindings.define 'visible', (el,property) ->
  if @[property]
    el.css 'display', 'none'
  else
    el.css 'display', 'block'