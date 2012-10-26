MVC = {}
Logging = {}
Utils = {}
Store = {}


###
--------------- /home/gdot/github/crystal/source/types/array.coffee--------------
###
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
###
--------------- /home/gdot/github/crystal/source/types/object.coffee--------------
###
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
###
--------------- /home/gdot/github/crystal/source/types/number.coffee--------------
###
Object.defineProperties Number::,
  # Date
  seconds:
    get: ->
      @valueOf() * 1e+3
  minutes:
    get: ->
      @valueOf() * 6e+4
  hours:
    get: ->
      @valueOf() * 3.6e+6
  days:
    get: ->
      @valueOf() * 8.64e+7
  # Iterators
  upto:
    value: (limit,func,bound = @) ->
      i = parseInt(@)
      while i <= limit
        func.call bound, i
        i++
  downto:
    value: (limit,func,bound = @) ->
      i = parseInt(@)
      while i >= limit
        func.call bound, i
        i--
  times:
    value: (func,bound = @) ->
      for i in [1..parseInt(@)]
        func.call bound, i
  # Utility
  clamp:
    value: (min,max) ->
      min = parseFloat(min)
      max = parseFloat(max)
      val = @valueOf()
      if val > max
        max
      else if val < min
        min
      else
        val
  clampRange:
    value: (min,max) ->
      min = parseFloat(min)
      max = parseFloat(max)
      val = @valueOf()
      if val > max
        val % max
      else if val < min
        max - Math.abs(val % max)
      else
        val
###
--------------- /home/gdot/github/crystal/source/types/date.coffee--------------
###
# @require ./number
Date.Locale = 
  ago:
    seconds: " seconds ago"
    minutes: " minutes ago"
    hours: " hours ago"
    days: " days ago"
    now: "just now"
  format: "%Y-%M-%D"

Object.defineProperties Date::,
  ago:
    get: ->
      diff = +new Date()-@
      if diff < (1).seconds
        Date.Locale.ago.now
      else if diff < (1).minutes
        Math.round(diff/1000)+Date.Locale.ago.seconds
      else if diff < (1).hours
        Math.round(diff/(1).minutes)+Date.Locale.ago.minutes
      else if diff < (1).days
        Math.round(diff/(1).hours)+Date.Locale.ago.hours
      else if diff < (30).days
        Math.round(diff/(1).days)+Date.Locale.ago.days
      else
        @format Date.Locale.format

  # TODO localization
  format:
    value: (str = Date.Locale.format) ->
      str.replace /%([a-zA-z])/g, ($0,$1) =>
        switch $1
          # Day
          when 'D'
            @getDate().toString().replace /^\d$/, "0$&"
          when 'd'
            @getDate()
          # Year
          when 'Y'
            @getFullYear()
          # Hours
          when 'h'
            @getHours()
          when 'H'
            @getHours().toString().replace /^\d$/, "0$&"
          # Month
          when 'M'
            (@getMonth()+1).toString().replace /^\d$/, "0$&"
          when 'm'
            @getMonth()+1
          # Minutes
          when "T"
            @getMinutes().toString().replace /^\d$/, "0$&"
          when "t"
            @getMinutes()
          else
            ""

['day:Date','year:FullYear','hours:Hours','minutes:Minutes','seconds:Seconds'].forEach (item) ->
  [prop,meth] = item.split(/:/)
  Object.defineProperty Date::, prop,
    get: ->
      @["get"+meth]()
    set: (value)->
      @["set"+meth] parseInt(value)


Object.defineProperty Date::, 'month',
  get: -> @getMonth()+1
  set: (value) -> @setMonth value-1
###
--------------- /home/gdot/github/crystal/source/logger/logger.coffee--------------
###
# @requires ../types/array
# @requires ../types/object
# @requires ../types/number
# @requires ../types/date

window.Logger = class Logging.Logger
  @DEBUG: 4
  @INFO: 3
  @WARN: 2
  @ERROR: 1
  @FATAL: 0
  @LOG: 4

  constructor: (level = 4) ->
    throw "Level must be Number" if isNaN parseInt(level)
    @_level = parseInt(level).clamp 0, 4
    @_timestamp = true

  _format: (args...) ->
    line = ""
    if @timestamp
      line += "["+new Date().format("%Y-%M-%D %H:%T")+"] "
    line += args.map((arg) -> args.toString()).join ","

Object.defineProperties Logger::,
  timestamp:
    set: (value) ->
      @_timestamp = !!value
    get: ->
      @_timestamp
  level:
    set: (value) ->
      @_level = parseInt(value).clamp 0, 4
    get: ->
      @_level

['debug', 'log', 'error', 'fatal', 'info', 'warn'].forEach (type) ->
  Logger::["_"+type] = ->
  Logger::[type] = (args...) ->
    if @level >= Logging.Logger[type.toUpperCase()]
      @["_"+type] @_format args
###
--------------- /home/gdot/github/crystal/source/logger/console-logger.coffee--------------
###
# @requires ./logger

window.ConsoleLogger = class Logging.ConsoleLogger extends Logging.Logger
  constructor: -> super

['debug', 'error', 'fatal', 'info', 'warn','log'].forEach (type) ->
  ConsoleLogger::["_"+type] = (text) ->
    type = 'log' if type is 'debug'
    type = 'error' if type is 'fatal'
    console[type] text
###
--------------- /home/gdot/github/crystal/source/dom/element.coffee--------------
###
# @requires ../types/object
# @requires ../types/array

# TODO Simpler
Attributes =
  title:{ prefix: "!", unique: true }
  name:{ prefix: "&", unique: true }
  type:{ prefix: "%", unique: true }
  id:{ prefix: "#", unique: true }
  class:{ prefix: "\\.", unique: false }
  role:{ prefix: "~", unique: true }

prefixes = Object.pluck(Attributes,'prefix').concat("$").join("|")
Object.each Attributes, (key,value) ->
  value.regexp = new RegExp value.prefix+"(.*?)(?=#{prefixes})", "g"


# Utility Functions
_wrap = NodeList._wrap = (fn) ->
  (args...) ->
    for el in @
      fn.apply el, args

_find = (property, selector, el) ->
  while el = el[property]
    if el instanceof Element
      if el.webkitMatchesSelector selector
        return el

# Parse attributes from string (#id.class!title)
_parseName = (name,atts = {}) ->
  cssattributes = {}
  name = name.replace /\[(.*?)=(.*?)\]/g, (m, name, value)->
    cssattributes[name] = value
    ""
  name = name.replace /\[(.*)?\]/g, (m, name)->
    cssattributes[name] = true
    ""
  ret =
    tag: name.match(new RegExp("^.*?(?=#{prefixes})"))[0] or 'div'
    attributes: cssattributes
  Object.each Attributes, (key,value) ->
    if (m = name.match(value.regexp)) isnt null
      name = name.replace(value.regexp, "")
      if value.unique
        if atts[key]
          ret.attributes[key] = atts[key] if atts[key] isnt null and atts[key] isnt undefined
        else
          ret.attributes[key] = m.pop().slice(1)
      else
        map = m.map (item) -> item.slice(1)
        if atts[key]
          if typeof atts[key] is 'string'
            map = map.concat atts[key].split(" ")
          else
            map = map.concat atts[key]
        ret.attributes[key] = map.compact().join(" ")
    else
      ret.attributes[key] = atts[key] if atts[key] isnt null and atts[key] isnt undefined
  ret

# Methods for Node
methods_node =
  append: (elements...) ->
    @appendChild el for el in elements when el instanceof Node
  first: (selector = "*") ->
    @querySelector selector
  last: (selector = "*") ->
    @querySelectorAll(selector).last
  all: (selector = "*") ->
    @querySelectorAll(selector)
  empty: ->
    @querySelectorAll("*").dispose()
  moveUp: ->
    @parent.insertBefore @, prev if @parent and (prev = @prev())
  moveDown: ->
    @parent.insertBefore next, @ if @parent and (next = @next())
  indexOf: (el) ->
    Array::slice.call(@childNodes).indexOf el

# Methods only for HTMLElement, NodeList
methods_element =
  dispose: ->
    @parent?.removeChild @
  # TODO implement these with TreeWalker
  ancestor: (selector = "*") ->
    _find 'parentElement', selector, @
  next: (selector = "*") ->
    _find 'nextSibling', selector, @
  prev: (selector = "*") ->
    _find 'previousSibling', selector, @
  # http://www.quirksmode.org/dom/getstyles.html
  css: (args...) ->
    property = args[0]
    if args.length is 1
      if @currentStyle
        value = @currentStyle[property]
      else
        value = window.getComputedStyle(@)[property]
      return value
    if args.length is 2
      value = args[1]
      @style[property] = value

for key, method of methods_node
  Object.defineProperty Node::, key, value: method

for key, method of methods_element
  Object.defineProperty NodeList::, key, value: _wrap method
  Object.defineProperty HTMLElement::, key, value: method

Object.defineProperty HTMLSelectElement::, 'selectedOption',
  get: ->
    @children[@selectedIndex] if @children
  set: (el) ->
    @selectedIndex = Array::slice.call(@children).indexOf(el) if @childNodes.include(el)

Object.defineProperty HTMLInputElement::, 'caretToEnd', value: ->
  length = @value.length
  @setSelectionRange(length, length)

properties = 
  id:
    get: -> @getAttribute 'id'
    set: (value) -> @setAttribute 'id', value
  tag:
    get: -> @tagName.toLowerCase()
  parent:
    get: -> @parentElement
    set: (el) ->
      return unless el instanceof HTMLElement
      el.append @
  text:
    get: -> @textContent
    set: (value) -> @textContent = value
  html:
    get: -> @innerHTML
    set: (value) -> @innerHTML = value
  class:
    get: -> @getAttribute 'class'
    set: (value) -> @setAttribute 'class', value

Object.defineProperties HTMLElement::, properties

Object.defineProperty Node::, 'delegateEventListener', value: (event,listener,useCapture) ->
  [baseEvent,selector] = event.split(':')
  selector ?= "*"
  @addEventListener baseEvent, (e) ->
    target = e.relatedTarget or e.target
    listener e if target.webkitMatchesSelector selector
  , true

['addEventListener','removeEventListener','delegateEventListener'].forEach (prop) ->
  Object.defineProperty Node::, prop.replace("Listener",''), value: Node::[prop]
  Object.defineProperty window, prop.replace("Listener",''), value: window[prop]

Element.create = (node, atts = {}) ->
  return node if node instanceof Node
  switch typeof node
    when 'string'
      {tag,attributes} = _parseName node, atts
      node = document.createElement tag.replace /[^A-Za-z_\-0-9]/, ''
      for key, value of attributes
        if (desc = properties[key])
          node[key] = value
          continue
        node.setAttribute key, value
    else
      node = document.createElement 'div'
  node

Node

###
--------------- /home/gdot/github/crystal/source/logger/flash-logger.coffee--------------
###
# @requires ./logger
# @requires ../dom/element

window.FlashLogger = class Logging.FlashLogger extends Logging.Logger
  constructor: (el, level) ->
    throw "Base Element must be HTMLElement" unless el instanceof HTMLElement
    super level
    @visible = false
    @el = el
  hide: ->
    clearTimeout @id
    @id = setTimeout =>
      @visible = false
      @el.classList.toggle 'hidden'
      @el.classList.toggle 'visible'
    , 2000

['debug', 'error', 'fatal', 'info', 'warn','log'].forEach (type) ->
  FlashLogger::["_"+type] = (text) ->
    if @visible
      @el.html += "</br>"+text
      @hide()
    else
      @el.text = text
      @el.classList.toggle 'hidden'
      @el.classList.toggle 'visible'
      @visible = true
      @hide()

###
--------------- /home/gdot/github/crystal/source/logger/html-logger.coffee--------------
###
# @requires ./logger
# @requires ../dom/element

css =
  error:
    color: 'orangered'
  info:
    color: 'blue'
  warn:
    color: 'orange'
  fatal:
    color: 'red'
    'font-weight': 'bold'
  debug:
    color: 'black'
  log:
    color: 'black'

window.HTMLLogger = class Logging.HTMLLogger extends Logging.Logger
  constructor: (el, level) ->
    throw "Base Element must be HTMLElement" unless el instanceof HTMLElement
    super level
    @el = el

['debug', 'error', 'fatal', 'info', 'warn','log'].forEach (type) ->
  HTMLLogger::["_"+type] = (text) ->
    el = Element.create 'div.'+type
    for prop, value of css[type]
      el.css prop, value
    el.text = text
    @el.append el
    el
###
--------------- /home/gdot/github/crystal/source/types/keyboard-event.coffee--------------
###
SPECIAL_KEYS = 
    0   : "\\"          # Firefox reports this keyCode when shift is held
    8   : "backspace"
    9   : "tab"
    12  : "num"
    13  : "enter"
    16  : "shift"
    17  : "ctrl"
    18  : "alt"
    19  : "pause"
    20  : "capslock"
    27  : "esc"
    32  : "space"
    33  : "pageup"
    34  : "pagedown"
    35  : "end"
    36  : "home"
    37  : "left"
    38  : "up"
    39  : "right"
    40  : "down"
    44  : "print"
    45  : "insert"
    46  : "delete"
    48  : "0"
    49  : "1"
    50  : "2"
    51  : "3"
    52  : "4"
    53  : "5"
    54  : "6"
    55  : "7"
    56  : "8"
    57  : "9"
    65  : "a"
    66  : "b"
    67  : "c"
    68  : "d"
    69  : "e"
    70  : "f"
    71  : "g"
    72  : "h"
    73  : "i"
    74  : "j"
    75  : "k"
    76  : "l"
    77  : "m"
    78  : "n"
    79  : "o"
    80  : "p"
    81  : "q"
    82  : "r"
    83  : "s"
    84  : "t"
    85  : "u"
    86  : "v"
    87  : "w"
    88  : "x"
    89  : "y"
    90  : "z"
    91  : "cmd"
    92  : "cmd"
    93  : "cmd"
    96  : "num_0"
    97  : "num_1"
    98  : "num_2"
    99  : "num_3"
    100 : "num_4"
    101 : "num_5"
    102 : "num_6"
    103 : "num_7"
    104 : "num_8"
    105 : "num_9"
    106 : "multiply"
    107 : "add"
    108 : "enter"
    109 : "subtract"
    110 : "decimal"
    111 : "divide"
    124 : "print"
    144 : "num"
    145 : "scroll"
    186 : ";"
    187 : "="
    188 : ","
    189 : "-"
    190 : "."
    191 : "/"
    192 : "`"
    219 : "["
    220 : "\\"
    221 : "]"
    222 : "\'"
    224 : "cmd"
    57392   : "ctrl"
    63289   : "num"

Object.defineProperty KeyboardEvent::, 'key', get: ->
  return key if key = SPECIAL_KEYS[@keyCode]
  String.fromCharCode(@keyCode).toLowerCase()
###
--------------- /home/gdot/github/crystal/source/utils/keyboard.coffee--------------
###
# @requires ../types/keyboard-event
window.Keyboard = class Keyboard
  handleKeydown: (e) =>
    delimeters = /-|\+|:|_/g
    unless e.cancelled
      combo = []
      combo.push "ctrl" if e.ctrlKey
      combo.push "shift" if e.shiftKey
      combo.push "alt" if e.altKey
      combo.push e.key
      for sc, method of @
        pressed = true
        for key in sc.split delimeters
          if combo.indexOf(key) is -1
            pressed = false
            break
        if pressed
          method.call @
          e.preventDefault()
          e.cancelled = true
          e.stopPropagation()
          break
  constructor: (@focus = false)->
    document.addEventListener 'keydown', (e) =>
      if @focus
        if document.first(":focus")
          @handleKeydown e
      else
        unless document.first(':focus')
          @handleKeydown e
    @initialize?()
###
--------------- /home/gdot/github/crystal/source/utils/json.coffee--------------
###
# FIX Stringify
olds = JSON.stringify
JSON.stringify = (obj) ->
  if obj instanceof Array
    olds Array::slice.call obj
  else
    olds obj
###
--------------- /home/gdot/github/crystal/source/utils/history.coffee--------------
###
window.History = class Utils.History
  constructor: ->
    @_type = if 'pushState' of history then 'popstate' else 'hashchange'
    window.addEventListener @_type, (event) =>
      url = switch @_type
        when 'popstate'
          window.location.pathname
        when 'hashchange'
          window.location.hash
      @[url.trim()]() if @[url.trim()] instanceof Function
    @stateid = 0
  push: (url) ->
    switch @_type
      when 'popstate'
        history.pushState {}, @stateid++, url
      when 'hashchange'
        window.location.hash = url


###
--------------- /home/gdot/github/crystal/source/utils/path.coffee--------------
###
window.Path = class Utils.Path
  constructor: (@context = {}) ->

  create: (path,value) ->
    path = path.toString()
    last = @context
    prop = (path = path.split(/\./)).pop()
    for segment in path
      if not last.hasOwnProperty(segment)
        last[segment] = {}
      last = last[segment]
    last[prop] = value

  exists: (path) ->
    @lookup(path) isnt undefined

  lookup: (path) ->
    end = (path = path.split(/\./)).pop()
    if path.length is 0 and not @context.hasOwnProperty(end) then return undefined
    last = @context
    for segment in path
      if last.hasOwnProperty(segment) then last = last[segment] else return undefined
    if last.hasOwnProperty(end) then return last[end]
    undefined

###
--------------- /home/gdot/github/crystal/source/utils/i18n.coffee--------------
###
# @requires ./path
# @requires ../types/object

class i18n

  @locales: {}

  @t: (path) ->
    if arguments.length is 2
      if (arg = arguments[1]) instanceof Object
        params = arg
      else
        locale = arg
    if arguments.length is 3
      locale = arguments[2]
      params = arguments[1]
    locale ?= document.querySelector('html').getAttribute('lang') or 'en'
    _path = new Path @locales[locale]
    str = _path.lookup path
    unless str
      console.warn "No translation found for '#{path}' for locale '#{locale}'"
      return path
    str.replace /\{\{(.*?)\}\}/g, (m,prop) ->
      if params[prop] isnt undefined then params[prop].toString() else ''

window.i18n = i18n
###
--------------- /home/gdot/github/crystal/source/types/string.coffee--------------
###
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

###
--------------- /home/gdot/github/crystal/source/utils/request.coffee--------------
###
# @requires ../types/array
# @requires ../types/string
# @requires ../types/object

# TODO Errors, FileUpload, Progress Events etc...
window.Response = class Utils.Response
  constructor: (headers,body,status) ->
    @headers = headers
    @raw = body
    @status = status

types =
  script: ['text/javascript']
  html: ['text/html']
  JSON: ['text/json','application/json']
  XML: ['text/xml']

Object.each types, (key,value) ->
  Object.defineProperty Response::, 'is'+key.capitalize(), value: ->
    value.map( (type) => @headers['Content-Type'] is type).compact().length > 0

Object.defineProperty Response::, 'body', get: ->
  switch @headers['Content-Type']
    when "text/html"
      div = document.createElement('div')
      div.innerHTML = @raw
      df = document.createDocumentFragment()
      for node in Array::slice.call div.childNodes
        df.appendChild node
      df
    when "text/json", "application/json"
      try
        JSON.parse(@raw)
      catch e
        @raw
    when "text/xml"
      p = new DOMParser()
      p.parseFromString(@raw,"text/xml")
    else
      @raw

window.Request = class Utils.Request
  constructor: (url, headers = {}) ->
    @uri = url
    @headers = headers
    @_request = new XMLHttpRequest()
    @_request.onreadystatechange = @handleStateChange

  request: (method = 'GET' ,data, callback) ->
    if (@_request.readyState is 4) or (@_request.readyState is 0)
      if method.toUpperCase() is 'GET' and data isnt undefined and data isnt null
        @_request.open method, @uri+"?"+data.toQueryString()
      else
        @_request.open method, @uri
      for own key, value of @headers
        @_request.setRequestHeader key.toString(), value.toString()
      @_callback = callback
      @_request.send(data?.toFormData())

  parseResponseHeaders: ->
    r = {}
    @_request.getAllResponseHeaders().split(/\n/).compact().forEach (header) ->
      [key,value] = header.split(/:\s/)
      r[key.trim()] = value.trim()
    r

  handleStateChange: =>
    if @_request.readyState is 4
      headers = @parseResponseHeaders()
      body = @_request.response
      status = @_request.status
      @_callback new Response(headers,body,status)
      @_request.responseText

['get','post','put','delete','patch'].forEach (type) ->
  Request::[type] = ->
    if arguments.length is 2
      data = arguments[0]
      callback = arguments[1]
    else
      callback = arguments[0]
    @request type.toUpperCase(), data, callback


###
--------------- /home/gdot/github/crystal/source/utils/uri.coffee--------------
###
# @requires ../types/array

window.URI = class Utils.URI
  constructor: (uri = '') ->
    parser = document.createElement('a')
    parser.href = uri
    if !!(m=uri.match /\/\/(.*?):(.*?)@/)
        [m,@user,@password] = m
    @host = parser.hostname
    @protocol = parser.protocol.replace /:$/, ''
    if parser.port == "0"
      @port = 80
    else
      @port = parser.port or 80
    @hash = parser.hash.replace /^#/, ''
    @query = uri.match(/\?(.*?)(?:#|$)/)?[1].parseQueryString() or {}
    @path = parser.pathname.replace(/^\//, '')
    @parser = parser
    @

  toString: ->
    uri = @protocol
    uri += "://"
    if @user and @password
      uri += @user.toString()+":"+@password.toString()+"@"
    uri += @host
    uri += ":"+@port unless @port is 80
    uri += "/"+@path if @path isnt ""
    uri += "?"+@query.toQueryString() if Object.keys(@query).length > 0
    uri += "#"+@hash if @hash isnt ""
    uri



###
--------------- /home/gdot/github/crystal/source/utils/evented.coffee--------------
###
Crystal.Utils.Event = class Utils.Event
  constructor: (target) ->
    throw "No target" unless !!target
    throw "Invalid target!" unless target instanceof Object
    @cancelled = false
    @target = target
  stop: ->
    @cancelled = true

class Utils.Mediator
  constructor: ->
    @listeners = {}
  fireEvent: (type,args)->
    event = args.first
    throw "Not Utils.Event!" unless event instanceof Utils.Event
    if @listeners[type]
      for callback in @listeners[type]
        unless event.cancelled
          callback.apply event.target, args
  addListener: (type,callback) ->
    throw "Only functions can be added as callback" unless callback instanceof Function
    @listeners[type] = [] unless @listeners[type]
    @listeners[type].push callback
  removeListener: (type, callback) ->
    @listeners[type].remove$ callback
    delete @listeners[type] if @listeners[type].length is 0

window.Mediator = new Utils.Mediator

Crystal.Utils.Evented = class Utils.Evented
  constructor: ->

  _ensureMediator: ->
    unless @_mediator
      Object.defineProperty @, "_mediator", value: new Utils.Mediator

  toString: ->
    "[Object #{@__proto__.constructor.name}]"

  trigger: (type,args...) ->
    event = new Utils.Event @
    args.unshift event
    @_ensureMediator()
    @_mediator.fireEvent type, args

  on: (type, callback) ->
    @_ensureMediator()
    @_mediator.addListener type, callback

  off: (type,callback) ->
    @_ensureMediator()
    @_mediator.removeListener type, callback

  publish: (type,args...) ->
    event = new Utils.Event @
    args.unshift event
    Mediator.fireEvent type, args

  subscribe: (type,callback) ->
    Mediator.addListener type, callback

  unsubscribe: (type,callback) ->
    Mediator.removeListener type, callback
###
--------------- /home/gdot/github/crystal/source/utils/base64.coffee--------------
###
window.Base64 = new class Utils.Base64
  _keyStr: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="
  encode: (input) ->
    output = ""
    i = 0
    input = @UTF8Encode(input)
    while i < input.length
      chr1 = input.charCodeAt(i++)
      chr2 = input.charCodeAt(i++)
      chr3 = input.charCodeAt(i++)
      enc1 = chr1 >> 2
      enc2 = ((chr1 & 3) << 4) | (chr2 >> 4)
      enc3 = ((chr2 & 15) << 2) | (chr3 >> 6)
      enc4 = chr3 & 63
      if isNaN(chr2)
        enc3 = enc4 = 64
      else enc4 = 64  if isNaN(chr3)
      output = output + @_keyStr.charAt(enc1) + @_keyStr.charAt(enc2) + @_keyStr.charAt(enc3) + @_keyStr.charAt(enc4)
    output

  decode: (input) ->
    output = ""
    i = 0
    input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "")
    while i < input.length
      enc1 = @_keyStr.indexOf(input.charAt(i++))
      enc2 = @_keyStr.indexOf(input.charAt(i++))
      enc3 = @_keyStr.indexOf(input.charAt(i++))
      enc4 = @_keyStr.indexOf(input.charAt(i++))
      chr1 = (enc1 << 2) | (enc2 >> 4)
      chr2 = ((enc2 & 15) << 4) | (enc3 >> 2)
      chr3 = ((enc3 & 3) << 6) | enc4
      output = output + String.fromCharCode(chr1)
      output = output + String.fromCharCode(chr2)  unless enc3 is 64
      output = output + String.fromCharCode(chr3)  unless enc4 is 64
    output = @UTF8Decode(output)
    output

  UTF8Encode: (string) ->
    string = string.replace(/\r\n/g, "\n")
    utftext = ""
    n = 0
    while n < string.length
      c = string.charCodeAt(n)
      if c < 128
        utftext += String.fromCharCode(c)
      else if (c > 127) and (c < 2048)
        utftext += String.fromCharCode((c >> 6) | 192)
        utftext += String.fromCharCode((c & 63) | 128)
      else
        utftext += String.fromCharCode((c >> 12) | 224)
        utftext += String.fromCharCode(((c >> 6) & 63) | 128)
        utftext += String.fromCharCode((c & 63) | 128)
      n++
    utftext

  UTF8Decode: (utftext) ->
    string = ""
    i = 0
    c = c1 = c2 = 0
    while i < utftext.length
      c = utftext.charCodeAt(i)
      if c < 128
        string += String.fromCharCode(c)
        i++
      else if (c > 191) and (c < 224)
        c2 = utftext.charCodeAt(i + 1)
        string += String.fromCharCode(((c & 31) << 6) | (c2 & 63))
        i += 2
      else
        c2 = utftext.charCodeAt(i + 1)
        c3 = utftext.charCodeAt(i + 2)
        string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63))
        i += 3
    string

###
--------------- /home/gdot/github/crystal/source/mvc/model-view.coffee--------------
###
window.ModelView = class ModelView
  constructor: (@model, @view)->
    @__bindings__ = []
    for key,args of @bindings
      args = [args] unless args instanceof Array
      [selector,binding] = key.split '|'
      if Bindings[binding]
        @__bindings__.push [selector.trim(), binding.trim(), args]
    for key,fn of @events
      @view.delegateEvent key, fn.bind @
  render: ->
    for bobj in @__bindings__
      [selector,binding,args] = bobj
      args = args.dup()
      views = if selector is '.' then @view else @view.all(selector)
      args.unshift views
      Bindings[binding].apply @model, args
###
--------------- /home/gdot/github/crystal/source/mvc/model.coffee--------------
###
window.Model = class Model extends Crystal.Utils.Evented
  constructor: (data)->
    @_ensureProperties()
    for key,descriptor of @properties
      @_property key, descriptor
    for key,value of data
      if Object.getOwnPropertyDescriptor(@,key)
        @[key] = value

  _ensureProperties: ->
    unless @__properties__
      Object.defineProperty @, '__properties__',
        value: {}
        enumerable: false

  _property: (name, value)->
    Object.defineProperty @, name,
      get: ->
        @__properties__[name]
      set: (val) ->
        if value instanceof Function
          val = value val
        if val isnt @__properties__[name]
          @__properties__[name] = val
          @trigger 'change'
          @trigger 'change:'+name
      enumerable: true
###
--------------- /home/gdot/github/crystal/source/mvc/collection.coffee--------------
###
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
    @silent = true
    fn.call @
    @silent = false
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
    unless @silent
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
###
--------------- /home/gdot/github/crystal/source/mvc/bindings.coffee--------------
###
window.Bindings =
  define: (key,value) ->
    @[key] = value
Bindings.define 'text', (els,property) ->
  els.forEach (el) => el.text = @[property]
Bindings.define 'toggleClass', (el,property,cls) ->
  if @[property]
    el.classList.add cls
  else
    el.classList.remove cls
Bindings.define 'value', (els,property) ->
  els.forEach (el) =>
    el.value = @[property]
    el.addEvent 'input', =>
      @[property] = el.value

Bindings.define 'visible', (el,property) ->
  if @[property]
    el.css 'display', 'none'
  else
    el.css 'display', 'block
###
--------------- /home/gdot/github/crystal/source/types/color.coffee--------------
###
# @requires ./number
window.Color = class Color
  constructor: (color = "FFFFFF") ->
    color = color.toString()
    color = color.replace /\s/g, ''
    if (match = color.match /^#?([0-9a-f]{3}|[0-9a-f]{6})$/i)
      if color.match /^#/
        hex = color[1..]
      else
        hex = color
      if hex.length is 3
        hex = hex.replace(/([0-9a-f])/gi, '$1$1')
      @type = 'hex'
      @_hex = hex
      @_alpha = 100
      @_update 'hex'
    else if (match = color.match /^hsla?\((-?\d+),\s*(-?\d{1,3})%,\s*(-?\d{1,3})%(,\s*([01]?\.?\d*))?\)$/)?
      @type = 'hsl'
      @_hue = parseInt(match[1]).clampRange 0, 360
      @_saturation = parseInt(match[2]).clamp 0, 100
      @_lightness = parseInt(match[3]).clamp 0, 100
      @_alpha = parseInt(parseFloat(match[5])*100) || 100
      @_alpha = @_alpha.clamp 0, 100
      @type += if match[5] then "a" else ""
      @_update 'hsl'
    else if (match = color.match /^rgba?\((\d{1,3}),\s*(\d{1,3}),\s*(\d{1,3})(,\s*([01]?\.?\d*))?\)$/)?
      @type = 'rgb'
      @_red = parseInt(match[1]).clamp 0, 255
      @_green = parseInt(match[2]).clamp 0, 255
      @_blue = parseInt(match[3]).clamp 0, 255
      @_alpha = parseInt(parseFloat(match[5])*100) || 100
      @_alpha = @_alpha.clamp 0, 100
      @type += if match[5] then "a" else ""
      @_update 'rgb'
    else
      throw 'Wrong color format!'

  invert: ->
    @_red = 255 - @_red
    @_green = 255 - @_green
    @_blue = 255 - @_blue
    @_update 'rgb'
    @

  mix: (color2, alpha = 50) ->
    color2 = new Color(color2) unless color2 instanceof Color
    c = new Color()
    for item in ['red','green','blue']
      c[item] = Math.round((color2[item] / 100 * (100 - alpha))+(@[item] / 100 * alpha)).clamp 0, 255
    c

  _hsl2rgb: ->
    h = @_hue / 360
    s = @_saturation / 100
    l = @_lightness / 100
    if s is 0
      val = Math.round(l * 255)
      @_red = val
      @_green = val
      @_blue =val
    if l < 0.5
      t2 = l * (1 + s)
    else
      t2 = l + s - l * s
    t1 = 2 * l - t2
    rgb = [ 0, 0, 0 ]
    i = 0

    while i < 3
      t3 = h + 1 / 3 * -(i - 1)
      t3 < 0 and t3++
      t3 > 1 and t3--
      if 6 * t3 < 1
        val = t1 + (t2 - t1) * 6 * t3
      else if 2 * t3 < 1
        val = t2
      else if 3 * t3 < 2
        val = t1 + (t2 - t1) * (2 / 3 - t3) * 6
      else
        val = t1
      rgb[i] = val * 255
      i++
    @_red = Math.round(rgb[0])
    @_green = Math.round(rgb[1])
    @_blue = Math.round(rgb[2])

  _hex2rgb: ->
    value = parseInt(@_hex, 16)
    @_red = value >> 16
    @_green = (value >> 8) & 0xFF
    @_blue = value & 0xFF

  _rgb2hex: ->
    value = (@_red << 16 | (@_green << 8) & 0xffff | @_blue)
    x = value.toString(16)
    x = '000000'.substr(0, 6 - x.length) + x
    @_hex = x.toUpperCase()

  _rgb2hsl: ->
    r = @_red / 255
    g = @_green / 255
    b = @_blue / 255
    min = Math.min(r, g, b)
    max = Math.max(r, g, b)
    delta = max - min
    if max is min
      h = 0
    else if r is max
      h = (g - b) / delta
    else if g is max
      h = 2 + (b - r) / delta
    else h = 4 + (r - g) / delta  if b is max
    h = Math.min(h * 60, 360)
    h += 360  if h < 0
    l = (min + max) / 2
    if max is min
      s = 0
    else if l <= 0.5
      s = delta / (max + min)
    else
      s = delta / (2 - max - min)
    @_hue = h
    @_saturation = s * 100
    @_lightness = l *100

  _update: (type) ->
    switch type
      when 'rgb'
        @_rgb2hsl()
        @_rgb2hex()
      when 'hsl'
        @_hsl2rgb()
        @_rgb2hex()
      when 'hex'
        @_hex2rgb()
        @_rgb2hsl()

  toString: (type = 'hex')->
    switch type
      when "rgb"
        "rgb(#{@_red}, #{@_green}, #{@_blue})"
      when "rgba"
        "rgba(#{@_red}, #{@_green}, #{@_blue}, #{@alpha/100})"
      when "hsl"
        "hsl(#{@_hue}, #{Math.round(@_saturation)}%, #{Math.round(@_lightness)}%)"
      when "hsla"
        "hsla(#{@_hue}, #{Math.round(@_saturation)}%, #{Math.round(@_lightness)}%, #{@alpha/100})"
      when "hex"
        @hex

['red','green','blue'].forEach (item) ->
  Object.defineProperty Color::, item,
    get: ->
      @["_"+item]
    set: (value) ->
      @["_"+item] = parseInt(value).clamp 0, 255
      @_update 'rgb'

['lightness','saturation'].forEach (item) ->
  Object.defineProperty Color::, item,
    get: ->
      @["_"+item]
    set: (value) ->
      @["_"+item] = parseInt(value).clamp 0, 100
      @_update 'hsl'

['rgba','rgb','hsla','hsl'].forEach (item) ->
  Object.defineProperty Color::, item,
    get: ->
      @toString(item)

Object.defineProperties Color::,
  hex:
    get: ->
      @_hex
    set: (value) ->
      @_hex = value
      @_update 'hex'
  hue:
    get: ->
      @_hue
    set: (value) ->
      @_hue = parseInt(value).clampRange 0, 360
      @_update 'hsl'
  alpha:
    get: ->
      @_alpha
    set: (value) ->
      @_alpha = parseInt(value).clamp 0, 100
###
--------------- /home/gdot/github/crystal/source/types/function.coffee--------------
###
Object.defineProperties Function::,
  delay:
    value: (ms,bind = @,args...) ->
      id = setTimeout =>
        @apply bind, args
        clearTimeout id
      , ms
  periodical:
    value: (ms,bind = @, args...) ->
      setInterval =>
        @apply bind, args
      , ms
###
--------------- /home/gdot/github/crystal/source/types/unit.coffee--------------
###
window.Unit = class Unit
  @UNITS: {px: true,  em: true}
  constructor: (value = "0px", basePX = 16) ->
    @base = basePX
    @set value

  toString: (type = "px") ->
    return @_value+"px" unless type of Unit.UNITS
    if type is 'em'
      (@_value / @base)+"em"
    else
      return @_value+"px"

  set: (value) ->
    if(match = value.match /(\d+)(px|em)$/)
      [m,value,type] = match
      v = parseFloat(value) or 0
      if type is 'em'
        @_value = parseInt(@base*v)
      else
        @_value = parseInt(v)
    else
      throw 'Wrong Unit format!'

['px','em'].forEach (type) ->
  Object.defineProperty Unit::, type,
    get: ->
      @toString(type)
###
--------------- /home/gdot/github/crystal/source/crystal.coffee--------------
###
Types = {}
###
--------------- /home/gdot/github/crystal/source/dom/node-list.coffee--------------
###
Object.defineProperties NodeList::,
  forEach:
    value: (fn, bound = @) ->
      for node,i in @
        fn.call bound, node, i
      @
  map:
    value: (fn, bound = @) ->
      for node in @
        fn.call bound, node
  pluck:
    value: (property) ->
      for node in @
        node[property]
  include:
    value: (el) ->
      for node in @
        return true if node is el
      false
  first:
    get: ->
      @[0]
  last:
    get: ->
      @[@length - 1]    
###
--------------- /home/gdot/github/crystal/source/dom/document-fragment.coffee--------------
###
Object.defineProperties DocumentFragment::
  children:
    get: ->
      @childNodes
  remove:
    value: (el) ->
      for node in @childNodes
        if node is el
          @removeChild el
      @

DocumentFragment.Create = ->
  document.createDocumentFragment()
###
--------------- /home/gdot/github/crystal/source/app/view.coffee--------------
###

###
--------------- /home/gdot/github/crystal/source/app/app.coffee--------------
###
# @requries ../utils/evented

_wrap = (name, app)->
  (data,fn) ->
    if data instanceof Object
      for key, value of data
        app[name].call app, key, value
    else
      app[name].call app, data, fn

window.Application = class Application extends Utils.Evented
  constructor: ->
    @logger = new ConsoleLogger
    @keyboard = new Keyboard
    @router = new History
    window.addEvent 'load', => @trigger 'load'
    ###
    nw > 3.0
    if PLATFORM is Platforms.NODE_WEBKIT
      win = require('nw.gui').Window.get()
      win.on 'close', ->
      win.on 'minimize', => @trigger 'minimize'
    ###

  set: (name,value) ->
    switch name
      when "logger"
        @logger = new value
      else
        @[name] = value

  get: (key, fn)->
    @router[key] = fn.bind @
  sc: (key, fn) ->
    @keyboard[key] = fn.bind @
  def: (key, fn) ->
    @[key] = fn

  event: (key,fn) ->
    document.delegateEvent key, fn.bind @

  on: (name,fn)->
    if name is 'end'
      window.onbeforeunload = fn
    else
      super

  subscribe: (name, callback)->
    super name, callback.bind @

  @new: (func) ->
    @app = new Application
    context = {}
    for key of @app
      context[key] = _wrap(key,@app)
    func.call context
    @app
###
--------------- /home/gdot/github/crystal/source/app/env.coffee--------------
###
window.Platforms = 
  WEBSTORE: 1
  NODE_WEBKIT: 2
  WEB:3
  
window.PLATFORM = if window.location.href.match(/^chrome-extension\:\/\//)
    Platforms.WEBSTORE
  else if 'require' of window
    Platforms.NODE_WEBKIT
  else
    Platforms.WEB
###
--------------- /home/gdot/github/crystal/source/store/store.coffee--------------
###
window.Store = class Store.Store
  constructor: (options = {})->
    
    @prefix = options.prefix or ""
    ad = parseInt(options.adapter) or 0
    
    @$serialize = options.serialize if options.serialize instanceof Function
    @$deserialize = options.deserialize if options.deserialize instanceof Function
    
    a = window
    indexedDB = 'indexedDB' of a or 'webkitIndexedDB' of a or 'mozIndexedDB' of a
    requestFileSystem = 'requestFileSystem' of a or 'webkitRequestFileSystem' of a
    websql = 'openDatabase' of a
    localStore = 'localStorage' of a
    xhr = 'XMLHttpRequest' of a
    
    adapter = switch ad
      when 0
        if indexedDB
          Store.IndexedDB
        else if websql
          Store.WebSQL
        else if requestFileSystem
          Store.FileSystem
        else if xhr
          Store.Request
        else if localStorage
          Store.LocalStorage
        else
          Store.Memory
      when 1
        throw "IndexedDB not supported!" unless indexedDB
        Store.IndexedDB
      when 2
        throw "WebSQL not supported!" unless websql
        Store.WebSQL
      when 3
        throw "FileSystem not supported!" unless requestFileSystem
        Store.FileSystem
      when 4
        throw "LocalStorage not supported!" unless localStorage
        Store.LocalStorage
      when 5
        throw "XHR not supported!" unless xhr
        Store.Request
      when 6
        Store.Memory
      else
        throw "Adapter not found!"
    
    ['get','set','remove','list'].forEach (item) =>
        @[item] = ->
          args = Array::slice.call arguments
          if @running
            @chain item, args
          else
            @call item, args
          @
    
    @$chain = []
    
    @adapter = new adapter()
    
    @adapter.init.call @, (store) =>
      @ready = true
      options.callback? @
      @callChain()
  
  error: ->
    console.error arguments
  
  serialize: (obj) -> 
    if @$serialize
      return @$serialize obj
    JSON.stringify obj
  deserialize: (json) ->
    if @$deserialize
      return @$deserialize obj
    JSON.parse json 
  
  chain: (type, args) ->
    @$chain.push [type, args]
  callChain: ->
    if @$chain.length > 0
      first = @$chain.shift()
      @call first[0], first[1]
      
  call: (type, args) ->
    unless @ready
      @chain type, args
    else
      @running = true
      if (type is 'set' and args.length is 3) or (type is 'list' and args.length is 1) or ((type is 'get' or type is 'remove') and args.length is 2)
        callback = args.pop()
      @adapter[type].apply @, args.concat (data) =>
        if typeof callback is 'function' then callback data
        @running = false
        @callChain()

  @ADAPTER_BEST = 0
  @INDEXED_DB = 1
  @WEB_SQL = 2
  @FILE_SYSTEM = 3
  @LOCAL_STORAGE = 4
  @XHR = 5
  @MEMORY = 6
###
--------------- /home/gdot/github/crystal/source/store/adapters/xhr.coffee--------------
###
# @requires ../store
# @requires ../../utils/request
window.Store.Request = class Store.XHR
  init: (callback) ->
    @request = new Request @prefix
    callback @
  get: (key, callback) ->
    @request.get {key:key}, (response) =>
      callback? @deserialize response.body
  set: (key, value, callback) ->
    @request.post {key:key, value: @serialize value}, (response) =>
      callback? response.body
  list: (callback) ->
    @request.get (response) =>
      callback? response.body
  remove: (key, callback) ->
    @request.delete {key:key}, (response) =>
      callback? response.body

###
--------------- /home/gdot/github/crystal/source/store/adapters/file-system.coffee--------------
###
# @requires ../store

window.Store.FileSystem = class Store.FileSystem

  init: (callback) ->
    rfs = window.RequestFileSystem || window.webkitRequestFileSystem
    rfs window.PRESISTENT, 50*1024*1024, (store) =>
      @storage = store
      callback @
    , @error

  list: (callback) ->
    dirReader = @storage.root.createReader()
    entries = []
    readEntries = =>
      dirReader.readEntries (results) ->
        if (!results.length)
          entries.sort()
          callback entries.map (item) ->
            item.name
        else 
          entries = entries.concat(Array::slice.call(results))
          readEntries()
      , @error
    readEntries()

  remove: (file, callback) ->
    @storage.root.getFile file, null, (fe) =>
      fe.remove ->
        callback true
      , ->
        callback false
    , ->
      callback false

  get: (file, callback) ->
    @storage.root.getFile file, null, (fe) =>
      fe.file (f) =>
        reader = new FileReader()
        reader.onloadend = (e) =>
          callback @deserialize e.target.result
        reader.readAsText f
      , ->
        callback false
    , ->
      callback false

  set: (file, data, callback = ->) ->
    @storage.root.getFile file, {create:true}, (fe) =>
      fe.createWriter (fileWriter) =>
        fileWriter.onwriteend = (e) =>
          callback true
        fileWriter.onerror = (e) =>
          callback false
        bb = new (window.WebKitBlobBuilder || BlobBuilder())
        bb.append(@serialize data)
        fileWriter.write(bb.getBlob('text/plain'))
      , ->
        callback false
    , ->
      callback false

###
--------------- /home/gdot/github/crystal/source/store/adapters/websql.coffee--------------
###
# @requires ../store

window.Store.WebSQL = class Store.WebSQL

    init: (callback) ->
      @exec = (statement, callback = (->), args) ->
        @db.transaction (tr) =>
          tr.executeSql statement, args, callback, (tr,err) =>
            callback false
          , ->
            callback false
      @db = openDatabase @prefix, '1.0', 'Store', 5 * 1024 * 1024
      @exec "CREATE TABLE IF NOT EXISTS store ( 'key' VARCHAR PRIMARY KEY NOT NULL, 'value' TEXT)", =>
        callback @

    get: (key, callback) ->
      @exec "SELECT * FROM store WHERE key = '#{key}'", (tr,result) =>
        if result.rows.length > 0
          ret = @deserialize result.rows.item(0).value
        else
          ret = false
        callback.call @, ret

    set: (key, value, callback) ->
      @exec "SELECT * FROM store WHERE key = '#{key}'", (tr,result) =>
        unless result.rows.length > 0
          @exec "INSERT INTO store (key, value) VALUES ('#{key}','#{@serialize value}')", (tr, result) =>
            if result.rowsAffected is 1
              callback true
            else
              callback false
        else
          @exec "UPDATE store SET value = '#{@serialize value}' WHERE key = '#{key}'", (tr, result) =>
            if result.rowsAffected is 1
              callback true
            else
              callback false

    list: (callback) ->
      @exec "SELECT key FROM store", (tr, results) =>
        keys = []
        if results.rows.length > 0
          [0..results.rows.length-1].forEach (i) ->
            keys.push results.rows.item(i).key
        callback keys

    remove: (key, callback) ->
      @exec "DELETE FROM store WHERE key = '#{key}'", (tr, result) =>
        if result.rowsAffected is 1
          callback true
        else
          callback false

###
--------------- /home/gdot/github/crystal/source/store/adapters/memory.coffee--------------
###
# @requires ../store

window.Store.Memory = class Store.Memory
  init: (callback) ->
    @store = {}
    callback? @

  get: (key, callback) -> 
    if (a = @store[key.toString()])
      ret = @deserialize a
    else
      ret = false
    callback? ret 

  set: (key, value, callback) ->
    try
      @store[key.toString()] = @serialize value
      ret = true 
    catch error
      @error error
    callback? ret or false

  list: (callback) ->
    ret = []
    try
      ret = for own key of @store 
        key
    catch error
      @error error
    callback? ret

  remove: (key, callback) ->
    if @store[key.toString()] is undefined
      callback false 
      return
    try
      delete @store[key.toString()]
      ret = true
    catch error
      @error error
    callback? ret or false

###
--------------- /home/gdot/github/crystal/source/store/adapters/indexed-db.coffee--------------
###
# @requires ../store

window.Store.IndexedDB = class Store.IndexedDB
    init: (callback) ->
      @version = "2"
      @database = 'store'
      a = window
      a.indexedDB = a.indexedDB || a.webkitIndexedDB || a.mozIndexedDB
      request = window.indexedDB.open(@prefix, @version)
      request.onupgradeneeded = (e) =>
        @db = e.target.result
        unless @db.objectStoreNames.contains("note")
          store = @db.createObjectStore(@database, keyPath: "key")
      request.onsuccess = (e) =>
        @db = e.target.result
        if 'setVersion' in @db
          unless @version is @db.version
            setVrequest = @db.setVersion(@version)
            setVrequest.onfailure = @error
            setVrequest.onsuccess = (e) =>
              store = @db.createObjectStore(@database, keyPath: "key")
              trans = setVrequest.result
              trans.oncomplete = ->
                callback @
          else
            callback @
        else
          callback @
      request.onfailure = @error
    
    get: (key, callback) ->
      trans = @db.transaction([@database], 'readwrite')
      store = trans.objectStore(@database)
      request = store.get key.toString()
      request.onerror = ->
        callback false
      request.onsuccess = (e) =>
        result = e.target.result
        if result
          callback @deserialize result.value
        else
          callback false

    set: (key, value, callback) ->
      trans = @db.transaction([@database], 'readwrite')
      store = trans.objectStore(@database)
      request = store.put(
        key: key.toString()
        value: @serialize value
      )
      request.onsuccess = ->
        callback true
      request.onerror = @error

    list: (callback) ->
      trans = @db.transaction([@database], 'readwrite')
      store = trans.objectStore(@database)
      cursorRequest = store.openCursor()
      cursorRequest.onerror = @error
      ret = []
      cursorRequest.onsuccess = (e) =>
        result = e.target.result
        if result 
          ret.push result.value.key
          result.continue()
        else
          callback ret

    remove: (key, callback) ->
      trans = @db.transaction([@database], 'readwrite')
      store = trans.objectStore(@database)  
      r = store.get key.toString()
      r.onerror = ->
        callback false
      r.onsuccess = (e) =>
        result = e.target.result
        if result
          r = store.delete key.toString() 
          r.onsuccess = -> 
            callback true
          r.onerror = ->
            callback false
        else
          callback false


###
--------------- /home/gdot/github/crystal/source/store/adapters/localstorage.coffee--------------
###
# @requires ../store

window.Store.LocalStorage = class Store.LocalStorage

  init: (callback) ->
    @prefix += "::" unless @prefix is ""
    callback @

  get: (key, callback) ->
    try
      ret = @deserialize localStorage.getItem @prefix+key.toString()
    catch error
      @error error
    callback ret or false

  set: (key, value, callback) ->
    try
      localStorage.setItem @prefix+key.toString(), @serialize value
      ret = true 
    catch error
      @error error
    callback ret or false

  list: (callback) ->
    ret = []
    for i in [0..localStorage.length-1]
      try
        key = localStorage.key(i)
        if @prefix != ""
          if new RegExp("^#{@prefix}").test key
            ret.push key.replace new RegExp("^#{@prefix}"), ""
        else
          ret.push key
      catch error
        @error error
    callback ret

  remove: (key, callback) ->
    if localStorage.getItem(@prefix+key) is null
      callback false 
      return
    try
      localStorage.removeItem @prefix+key.toString()
      ret = true
    catch error
      @error error
    callback ret or false
###
--------------- /home/gdot/github/crystal/source/ui/list.coffee--------------
###
window.UI = {}

UI.List = class List extends Crystal.Utils.Evented
  indexOf: (el) -> @base.indexOf el
  itemOf: (el) -> @collection[@base.indexOf el]

  change: (data) ->
    for item in data.added
      if @options.element instanceof HTMLElement
        el = @options.element.cloneNode(true)
      else
        el = Element.create @options.element
      if @options.prepare instanceof Function
        @options.prepare.call @, el, item[0]
      @add el, item[1]
    @remove data.removed
    @move data.moved

  add: (el,index) ->
    @base.insertBefore el, @base.childNodes[index]

  remove: (indexes) ->
    (for index in indexes
      @base.childNodes[index]).forEach (el) -> el.dispose()

  move: (moves) ->
    elements = moves.map (move) => @base.childNodes[move[0]]
    for el, i in elements
      @base.insertBefore el, @base.childNodes[moves[i][1]]

  constructor: (@options) ->
    @base = Element.create()
    @collection = @options.collection
    @collection.on 'change', (e,data) => @change data