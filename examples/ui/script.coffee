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
      data = localStorage.getItem('data')
      data?.split("|").forEach (todo) => @push todo
    save: ->
      localStorage.setItem 'data', @join "|"

  window.c = new ToDoCollection()


  l = new AbsoluteList
    collection:c
    zen: '.item'
    prepare: (el, item) ->
      el.text = item
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

  document.first("#add").addEvent 'click', ->
    window.loaded ?= true
    value = document.first("#text").value
    c.push value if text.value.trim() isnt ""
  document.delegateEvent 'click:i.icon-sort', (e) =>
    c.sort()
  document.first("#list").append l.base