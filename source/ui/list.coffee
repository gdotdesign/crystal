# @requires ../utils/evented
window.UI = {}
UI.List = class List extends Crystal.Utils.Evented
  indexOf: (el) -> @base.indexOf el
  itemOf: (el) -> @collection[@base.indexOf el]

  change: (e,data) =>
    for item in data.added
      if @options.element instanceof HTMLElement
        el = @options.element.cloneNode(true)
      else if @options.element instanceof Function
        el = @options.element item[0]
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
      what = @base.childNodes[moves[i][1]]
      if el and what
        @base.insertBefore el, what

  bind: (collection)->
    @base.empty()
    if @collection
      @collection.off 'change', @change
    @collection = collection
    @collection.on 'change', @change
    added = for item,i in @collection then [item,i]
    @change null, {added:added,removed: [], moved:[]}

  constructor: (@options) ->
    if @options.base instanceof HTMLElement
      @base = @options.base
    else
      @base = Element.create @options.base
    if @options.collection
      @bind @options.collection
