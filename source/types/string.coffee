# @requires ./number
# @requires ./array

Object.defineProperties String::,
  compact:
    value: ->
      s = @valueOf().trim()
      s.replace /\s+/g, ' '

  camelCase:
    value: ->
      @replace /[- _](\w)/g, (matches) ->
        matches[1].toUpperCase()
  hyphenate:
    value: ->
      @replace /[A-Z]/g, (match) ->
        "-"+match.toLowerCase()
  capitalize:
    value: ->
      @replace /^\w|\s\w/g, (match) ->
        match.toUpperCase()

  indent:
    value: (spaces = 2) ->
      s = ''
      spaces = spaces.times -> s+=" "
      @replace(/^/gm,s)
  outdent:
    value: (spaces = 2) ->
      @replace new RegExp("^\\s{#{spaces}}","gm"), ""

  entities:
    value: ->
      @replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;')
    
  parseQueryString:
    value: ->
      ret = {}
      regexp = /([^&=]+)=([^&]*)/g
      while match = regexp.exec(@)
        ret[decodeURIComponent(match[1])] = decodeURIComponent(match[2])
      ret

String.random = (length) ->
  chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz'.split('')
  if not length
    length = Math.floor(Math.random() * chars.length)
  str = ''
  for i in [0..length]
    str += chars.sample
  str
