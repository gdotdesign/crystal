# @requires ./number
methods =
  compact: ->
    s = @valueOf().trim()
    s.replace /\s+/g, ' '
  camelCase: ->
    @replace /[- _](\w)/g, (matches) ->
      matches[1].toUpperCase()
  hyphenate: ->
    @replace /[A-Z]/g, (match) ->
      "-"+match.toLowerCase()
  capitalize: ->
    @replace /^\w|\s\w/g, (match) ->
      match.toUpperCase()
  indent: (spaces = 2) ->
    s = ''
    spaces = spaces.times -> s+=" "
    @replace(/^/gm,s)
  outdent: (spaces = 2) ->
    @replace new RegExp("^\\s{#{spaces}}","gm"), ""
  entities: ->
    @replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;')
  parseQueryString: ->
    ret = {}
    regexp = /([^&=]+)=([^&]*)/g
    while match = regexp.exec(@)
      ret[decodeURIComponent(match[1])] = decodeURIComponent(match[2])
    ret

for key, method of methods
  Object.defineProperty String::, key, value: method

String.random = (length) ->
  chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz'.split('')
  if not length
    length = Math.floor(Math.random() * chars.length)
  str = ''
  for i in [0..length]
    str += chars[Math.floor(Math.random() * chars.length)]
  str
