define ->
  methods = 
    forEach: (fn, bound = @) ->
      for node in @
        fn.call bound, node
      @
    map: (fn, bound = @) ->
      for node in @
        fn.call bound, node
    pluck: (property) ->
      for node in @
        node[property]
    include: (el) ->
      for node in @
        return true if node is el
      false
      
  for key, method of methods
    Object.defineProperty NodeList::, key, value: method  

  Object.defineProperties NodeList::,
    first:
      get: ->
        @[0]
    last:
      get: ->
        @[@length - 1]    
  
  NodeList
