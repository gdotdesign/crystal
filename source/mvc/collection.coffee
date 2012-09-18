# @requires ../types/array
# @requires ../utils/evented

window.Collection = class MVC.Collection extends Array
  constructor: (args...) ->
    super
    @push.apply @, args
    @

  pop: ->
    item = super
    @trigger 'remove', item
    @trigger 'change'
    item

  push: ->
    oldl = @length
    l = super
    for item in arguments
      @trigger 'add', item
      @trigger 'change'
    l

  shift: ->
    item = super
    @trigger 'remove', item
    @trigger 'change'
    item

  reverse: ->
    r = super
    @trigger 'change'
    r

  sort: ->
    r = super
    @trigger 'change'
    r

  splice: (index, length, args...) ->
    a = for i in [index..index+length-1] then @[i]
    r = super
    for item in a
      @trigger 'remove', item if item
    for item in args
      @trigger 'add', item
    r

  unshift: ->
    l = super
    for item in arguments
      @trigger 'add', item
      @trigger 'change'
    l

for key, value of Evented::
  Collection::[key] = value
Collection