methods =
  remove$: (item) ->
    if (index = @indexOf(item)) != -1
      @splice index, 1
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
    b = new @__proto__.constructor
    @filter (item) ->
      b.push(item) unless b.include item
    b
  shuffle: ->
    shuffled = []
    @forEach (value, index) ->
      rand = Math.floor(Math.random() * (index + 1))
      shuffled[index] = shuffled[rand]
      shuffled[rand] = value
    shuffled
  compact: ->
    @filter (item) -> !!item
  dup: (item) ->
    @filter -> true
  pluck: (property) ->
    @map (item) ->
      item[property]
  include: (item) ->
    @indexOf(item) != -1

for key, method of methods
  Object.defineProperty Array::, key, value: method

Object.defineProperties Array::,
  sample:
    get: ->
      @[Math.floor(Math.random() * @length)]
  first:
    get: ->
      @[0]
  last:
    get: ->
      @[@length - 1]