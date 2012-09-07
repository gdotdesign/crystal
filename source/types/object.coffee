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

# @docs

#
# Extends native Object with utilility functions.
#
# @method #toFormData()
#   Creates a form data representation of the object.
#   This method is used for sending data to the server via XMLHTTPRequest.
#   @return [FormData] The FormData object
#
# @method #toQueryString()
#   Creates query string representation of the object.
#   @return [FormData] The FormData object
#
# @method .each()
#   Iterate thorugh the objects porperties
# @method .pluck()
#   Iterate thorugh the objects values and pull a single porperty of the value.
# @method .values()
#   Returns the object values (flattern as value)
# @method .canRespondTo()
#   Checks if the given function can be called on the object.
class Object