Object.defineProperties Object::,
  toFormData:
    value: ->
      ret = new FormData()
      for own key, value of @
        ret.append key, value
      ret
  toQueryString:
    value: ->
      (for own key, value of @
        "#{key}=#{value.toString()}").join "&"

Object.each = (object, fn) ->
  for own key, value of object
    fn.call object, key, value

Object.pluck = (object, prop) ->
  for own key, value of object
    value[prop]

Object.values = (object) ->
  for own key, value of object
    value

Object.canRespondTo = (object, args...) ->
  ret = true
  for arg in args
    ret = false unless typeof object[arg] is 'function'
  ret