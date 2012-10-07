# @requires ./number
# @requires ./array

Object.defineProperties String::,
  wordWrap:  
    value: (width = 15, separator = "\n", cut = false) ->
      regex = ".{1," + width + "}(\\s|$)" + ((if cut then "|.{" + width + "}|.+$" else "|\\S+?(\\s|$)"))
      @match(RegExp(regex, "g")).join(separator)
  test: 
    value: (regexp)->
      !!@match regexp
  escape:
    value: ->
      @replace /[-[\]{}()*+?.\/'\\^$|#]/g, "\\$&"
  ellipsis:
    value: (length = 10) ->
      if @length > length
        @[0..length-1]+"..."
      else
        @valueOf()
  compact:
    value: ->
      s = @valueOf().trim()
      s.replace /\s+/g, ' '

  camelCase:
    value: ->
      @replace /[- _](\w)/g, (matches) ->  matches[1].toUpperCase()
  hyphenate:
    value: ->
      @replace(/^[A-Z]/, (match) -> match.toLowerCase()).replace /[A-Z]/g, (match) -> "-"+match.toLowerCase()
  capitalize:
    value: ->
      @replace /^\w|\s\w/g, (match) ->  match.toUpperCase()

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

String.random = (length = 10) ->
  chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz'.split('')
  if not length
    length = Math.floor(Math.random() * chars.length)
  str = ''
  for i in [0..length-1]
    str += chars.sample
  str
