define ->
  # Iterators
  Object.defineProperty Array::, 'each', value: Array::forEach

  # Mutator Methods  
  ['compact','uniq','pluck','shuffle'].each (method) ->
    Object.defineProperty Array::, "_"+method, value: (args...) ->
      newArray = Array::[method].call @, args
      @_empty()
      for item in newArray
        @push item
      @

  methods = 
    _shift: ->
      @splice 0, 1
      @
    _empty: ->
      @splice 0, @length

    _remove: (item) ->
      if (index = @indexOf(item)) != -1
        @splice index, 1
      @
    _removeAll: (item) ->
      while (index = @indexOf(item)) != -1
        @splice index , 1
      @
    _push: (args...) ->
      Array::push.apply @, args
      @
    # Accessor Methods
    remove: (item) ->
      b = @dup()
      if (index = b.indexOf(item)) != -1
        b.splice index, 1
      b
    removeAll: (item) ->
      b = @dup()
      while (index = b.indexOf(item)) != -1
        b.splice index , 1
      b
    uniq: ->
      b = []
      @filter (item) ->
        b.push(item) unless b.include item
      b
    shuffle: ->
      shuffled = []
      @each (value, index) ->
        rand = Math.floor(Math.random() * (index + 1))
        shuffled[index] = shuffled[rand]
        shuffled[rand] = value
      shuffled
    pluck: (property) ->
      @map (item) ->
        item[property]
    compact: ->
      @filter (item) -> !!item
    include: (item) ->
      @indexOf(item) != -1
    dup: (item) ->
      @filter -> true   
      
  for key, method of methods
    Object.defineProperty Array::, key, value: method    
      
  Object.defineProperties Array::,
    first:
      get: ->
        @[0]
    last:
      get: ->
        @[@length - 1]    
  
  Array
