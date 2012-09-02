Object.defineProperties NodeList::,
  forEach:
    value: (fn, bound = @) ->
      for node,i in @
        fn.call bound, node, i
      @
  map:
    value: (fn, bound = @) ->
      for node in @
        fn.call bound, node
  pluck:
    value: (property) ->
      for node in @
        node[property]
  include:
    value: (el) ->
      for node in @
        return true if node is el
      false
  first:
    get: ->
      @[0]
  last:
    get: ->
      @[@length - 1]    