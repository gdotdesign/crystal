# Custom ListView for absolute positioning
class AbsoluteList extends UI.List
  indexOf: (el) -> parseInt(el.getAttribute('index'))
  itemOf: (el) -> @collection[@indexOf(el)]

  change: (e,data) ->
    for item in data.added
      if @options.element instanceof HTMLElement
        el = @options.element.cloneNode(true)
      else
        el = Element.create @options.element
      if @options.prepare instanceof Function
        @options.prepare.call @, el, item[0]
      @add el, item[1]
    @remove data.removed
    if data.removed.length > 0
      @move.delay 320, @, data.moved
    else
      @move data.moved

  render: ->
    i = 0
    elements = @base.childNodes.map((el) => {el:el, index:@indexOf(el)}).sort((a,b) -> a.index-b.index).pluck('el')
    for el in elements
      el.css 'position', 'absolute'
      el.css 'top', i*43+"px"
      i++

  add: (el,index)->
    el.setAttribute 'index', index
    el.addEvent 'webkitAnimationEnd', ->
      el.css '-webkit-animation', 'none'
    @base.append el
    @render()

  remove: (items)->
    elements = for index in items then @base.first("[index='#{index}']")
    for el in elements
      el.css '-webkit-transform', 'translateX(120%)'
      el.css 'opacity', 0
    setTimeout =>
      for el in elements
        el.dispose()
    , 320

  move: (moves)->
    elements = moves.map (move) => @base.first("[index='#{move[0]}']")
    for el,i in elements
      el.setAttribute 'index', moves[i][1]
    @render()
    @trigger 'moved'

# Model
window.ToDoItem = class ToDoItem extends Model
  properties:
    name: {}
    done: {}

# Collection
class ToDoCollection extends Collection
  constructor: ->
    @on 'change', (e,mutation) ->
      for item in mutation.added
        item[0].on 'change', @save
        item[0].on 'moveup', (e) =>
          index = @indexOf e.target
          @switch index-1, index
        item[0].on 'movedown', (e) =>
          index = @indexOf e.target
          @switch index+1, index
        item[0].on 'remove', (e) =>
          @remove$ e.target
      # for item in mutation.removed
      # TODO Garbage Collection
      @save()
    super
  load: ->
    if (data = JSON.parse localStorage.getItem('data'))
      data.forEach (todo) => @push new ToDoItem todo
  save: =>
    localStorage.setItem 'data', JSON.stringify @

# ModelView
class ToDoItemView extends ModelView
  bindings:
    '.text|text': 'name'
    '.|toggleClass': ['done', 'done']
    'input[type=text]|value': 'name'
  events:
    'dblclick': (e)->
      e.preventDefault()
      e.stopPropagation()
      @view.classList.toggle 'edit'
      @view.first('input').focus()
    'blur:input': ->
      @view.classList.toggle 'edit'
    'click:i.icon-chevron-down': (e)->
      @model.trigger 'movedown'
    'click:i.icon-chevron-up': (e)->
      @model.trigger 'moveup'
    'click:i.icon-ok': (e)->
      @model.done = !@model.done
    'click:i.icon-remove': (e)->
      @model.trigger 'remove'

  constructor: (model,view) ->
    super
    @model.on 'change', @render.bind @
    view.css '-webkit-animation-delay', 0 if window.loaded

# Application
window.todoapp = Application.new ->
  @def 'addItem', ->
    window.loaded ?= true
    value = @text.value
    if value.trim() isnt ""
      item = new ToDoItem({name: value, done: false})
      @collection.push item
    @text.value = ''

  @def 'chevrons', ->
    for view in @listView.base.childNodes
      index = @listView.indexOf view
      view.first('i.icon-chevron-down').classList.remove 'hidden'
      view.first('i.icon-chevron-up').classList.remove 'hidden'
      if index is 0
        view.first('i.icon-chevron-up').classList.add 'hidden'
      if index is @collection.length-1
       view.first('i.icon-chevron-down').classList.add 'hidden'

  @event
    'keydown:#text': (e)->
      @addItem() if e.key is 'enter'
    'click:i.icon-plus': ->
      @addItem()
    'click:i.icon-sort': (e) ->
      @collection.sort (a, b) ->
        if a.done and b.done
          if a.name is b.name
            0
          else if a.name < b.name
            -1
          else
            1
        else if a.done and !b.done
          1
        else
          -1
    'click:.menu i.icon-remove': (e) ->
      @collection.transaction ->
        dup = @dup()
        for item,i in dup
          @splice @indexOf(item), 1 if item.done

  @on 'load', ->
    @collection = new ToDoCollection()

    @text = @root.first('#text')
    @listEl = @root.first("#list")

    template = @root.first(".item")
    template.dispose()
    template.removeAttribute 'hidden'

    @listView = new AbsoluteList
      collection: @collection
      element: template
      prepare: (el, item) ->
        mv = new ToDoItemView(item,el)
        mv.render()
    @listView.base.dataset.empty = "No Items left! Yey!"
    @listEl.append @listView.base
    @listView.on 'moved', => @chevrons()
    @collection.on 'change', => @chevrons()
      
    @collection.load()
