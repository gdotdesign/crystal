define ['source/mvc/collection'], (Collection) ->
  window.a = new Collection('a','a','b','b')
  a.on "remove", (item)->
    console.log 'removed:'+item
  a.on "add", (item)->
    console.log 'added:'+item
