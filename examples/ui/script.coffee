window.onload = ->

  class AbsoluteList extends UI.List
    indexOf: (el) -> parseInt(el.getAttribute('index'))

    add: (el,index)->
      el.css 'opacity', '0'
      el.css 'position', 'absolute'
      el.css 'top', index*32+"px"
      el.setAttribute 'index', index
      el.addEvent 'webkitAnimationEnd', ->
        el.css '-webkit-animation', 'none'
      @base.append el
      setTimeout ->
        el.css 'opacity', '1'
      ,100

    remove: (items)->
      elements = for index in items then @base.first("[index='#{index}']")
      for el in elements
        el.css '-webkit-transform', 'translateX(120%)'
      setTimeout =>
        for el in elements
          el.dispose()
      , 320

    move: (moves)->
      elements = moves.map (move) => @base.first("[index='#{move[0]}']")
      for el,i in elements
        el.setAttribute 'index', moves[i][1]
        el.css 'top', moves[i][1]*32+"px"

  class ToDoCollection extends Collection
    constructor: ->
      @on 'change', ->
        @save()
      super
    load: ->
      data = JSON.parse localStorage.getItem('data') 
      data.forEach (todo) => @push new ToDoItem todo
    save: ->
      localStorage.setItem 'data', JSON.stringify @

  # ----------------------------
  _wrap = (name, proto, instance)->
    (data,fn) ->
      if data instanceof Object
        for key, value of data
          proto[name].call instance, key, value
      else
        proto[name].call instance, data, fn
  
  class Model extends Crystal.Utils.Evented
    _ensureProperties: ->
      unless @__properties__
        Object.defineProperty @, '__properties__',
          value: {}
          enumerable: false

    forEach: (fn) ->
      for key of @__properties__
        fn key, @[key]
      
    @property: (name, value)->
      Object.defineProperty @, name,
        get: ->
          @_ensureProperties()
          @__properties__[name]
        set: (val) ->
          @_ensureProperties()
          if value instanceof Function
            val = value val
          if val isnt @__properties__[name]
            @__properties__[name] = val
            @trigger 'change'
            @trigger 'change:'+name
        enumerable: true

    @create: (func) ->
      class extends Model
        constructor: (properties) ->
          context = {}
          for key of Model
            context[key] = _wrap(key,Model, @)
          func.call context
          for key,value of properties
            if Object.getOwnPropertyDescriptor(@,key)
              @[key] = value

  # FIX Stringify
  olds = JSON.stringify
  JSON.stringify = (obj) ->
    if obj instanceof Array
      olds Array::slice.call obj
    else
      olds obj

  # ----------------------------


  window.ToDoItem = Model.create ->
    @property 'name'
    @property 'done'

  window.c = new ToDoCollection()

  MV = class X extends ModelView

  l = new AbsoluteList
    collection:c
    zen: '.item'
    prepare: (el, item) ->
      el.text = item.name
      el.css '-webkit-animation-delay', 0 if window.loaded
      el.append Element.create 'i.icon-remove'
      el.append Element.create 'i.icon-ok'
      el.append Element.create 'i.icon-chevron-up'
      el.append Element.create 'i.icon-chevron-down'
      el.addEvent 'dblclick', (e)->
        e.preventDefault()
        e.stopPropagation()
        el.classList.toggle 'edit'
      el.delegateEvent 'click:i.icon-chevron-down', (e) =>
        index = @indexOf(e.target.parent)
        c.switch index+1, index
      el.delegateEvent 'click:i.icon-chevron-up', (e)=>
        index = @indexOf(e.target.parent)
        c.switch index-1, index
      el.delegateEvent 'click:i.icon-ok', (e) ->
        el.classList.toggle 'done'
      el.delegateEvent 'click:i.icon-remove', (e) =>
        index = @indexOf(e.target.parent)
        c.splice index, 1


  c.on 'change', ->
    for el in l.base.childNodes
      index = l.indexOf el
      el.first('i.icon-chevron-up').classList.remove 'hidden'
      el.first('i.icon-chevron-down').classList.remove 'hidden'
      if index is 0
        el.first('i.icon-chevron-up').classList.add 'hidden'
      if index is c.length-1
        el.first('i.icon-chevron-down').classList.add 'hidden'

  c.load()
  y = c[0]
  y.on 'change:name', ->
    console.log 'wtf'

  document.first("#add").addEvent 'click', ->
    window.loaded ?= true
    value = document.first("#text").value
    c.push new ToDoItem(name: value) if text.value.trim() isnt ""
    document.first("#text").value = ''
  document.delegateEvent 'click:i.icon-sort', (e) =>
    c.sort (a, b) ->
      return 0 if a.name is b.name
      if a.name < b.name
        -1
      else 
        1
  document.first("#list").append l.base