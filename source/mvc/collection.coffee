# @requires ../types/array
# @requires ../utils/evented

window.Collection = class MVC.Collection extends Array
  constructor: (args...) ->
    super
    if args.length > 0
      @push.apply @, args
    @

  transaction: (fn) ->
    old = @dup()
    fn.call @
    @_compare old
    @

  switch: (index1,index2) ->
    return unless 0 <= index1 <= @length-1
    return unless 0 <= index2 <= @length-1
    @transaction ->
      x = @[index2]
      @[index2] = @[index1]
      @[index1] = x
    @

  splice: (index,length,args...) ->
    old = @dup()
    r = Collection.__super__.splice.apply @, [index,length]
    items = args.uniq().compact().filter (item) => @indexOf(item) is -1
    items.unshift index, 0
    r = Collection.__super__.splice.apply @, items
    @_compare old
    r

  _compare: (old) ->

    n = @map((item,i) =>
      if old.indexOf(item) is -1
        [item,i]
      else false
    ).compact()

    moves = []
    removes = []
    old.map((item,i) =>
      index = @indexOf item
      if index isnt -1 and index isnt i
        moves.push [i,index]
      if index is -1
        removes.push i
    ).compact()

    @trigger 'change', {
      removed: removes
      added: n
      moved: moves
    }

['push','unshift'].forEach (key) ->
  Collection::[key] = (args...)->
    old = @dup()
    items = args.uniq().compact().filter (item) => @indexOf(item) is -1
    r = Array::[key].apply @, items
    @_compare old
    r

['pop','shift','sort','reverse'].forEach (key) ->
  Collection::[key] = (args...)->
    old = @dup()
    r = Array::[key].apply @, args
    @_compare old
    r

for key, value of Utils.Evented::
  Collection::[key] = value