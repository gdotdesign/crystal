window.UI = {}

UI.List = class List extends Crystal.Utils.Evented
  indexOf: (el) -> @base.indexOf el
  itemOf: (el) -> @collection[@base.indexOf el]

  change: (data) ->
    for item in data.added
      if @options.element instanceof HTMLElement
        el = @options.element.cloneNode(true)
      else
        el = Element.create @options.element
      if @options.prepare instanceof Function
        @options.prepare.call @, el, item[0]
      @add el, item[1]
    @remove data.removed
    @move data.moved

  add: (el,index) ->
    @base.insertBefore el, @base.childNodes[index]

  remove: (indexes) ->
    (for index in indexes
      @base.childNodes[index]).forEach (el) -> el.dispose()

  move: (moves) ->
    elements = moves.map (move) => @base.childNodes[move[0]]
    for el, i in elements
      @base.insertBefore el, @base.childNodes[moves[i][1]]

  constructor: (@options) ->
    @base = Element.create()
    @collection = @options.collection
    @collection.on 'change', (e,data) => @change data