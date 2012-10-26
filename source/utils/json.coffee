# FIX Stringify
olds = JSON.stringify
JSON.stringify = (obj) ->
  if obj instanceof Array
    olds Array::slice.call obj
  else
    olds obj