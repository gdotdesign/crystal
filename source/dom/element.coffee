# @requires ../types/object
# @requires ../types/array

# TODO Simpler
Attributes =
  title:
    prefix: "!"
    unique: true
  name:
    prefix: "&"
    unique: true
  type:
    prefix: "%"
    unique: true
  id:
    prefix: "#"
    unique: true
  class:
    prefix: "\\."
    unique: false
  role:
    prefix: "~"
    unique: true

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
    for el in elements
      if el instanceof Node
        @appendChild el
  first: (selector = "*") ->
    @querySelector selector
  last: (selector = "*") ->
    @querySelectorAll(selector).last
  all: (selector = "*") ->
    @querySelectorAll(selector)
  empty: ->
    @querySelectorAll("*").dispose()
  moveUp: ->
    if @parent and (prev = @prev())
      @parent.insertBefore @, prev
  moveDown: ->
    if @parent and (next = @next())
      @parent.insertBefore next, @

# Methods only for HTMLElement, NodeList
methods_element =
  dispose: ->
    @parent?.removeChild @
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
  tag:
    get: ->
      @tagName.toLowerCase()
  parent:
    get: ->
      @parentElement
    set: (el) ->
      return unless el instanceof HTMLElement
      el.append @
  text:
    get: ->
      @textContent
    set: (value) ->
      @textContent = value
  html:
    get: ->
      @innerHTML
    set: (value) ->
      @innerHTML = value
  class:
    get: ->
      @getAttribute 'class'
    set: (value) ->
      @setAttribute 'class', value
Object.defineProperties HTMLElement::, properties

Object.defineProperty Node::, 'delegateEventListener', value: (event,listener,useCapture) ->
  [baseEvent,selector] = event.split(':')
  selector ?= "*"
  @addEventListener baseEvent, (e) ->
    listener e if e.relatedTarget.webkitMatchesSelector selector

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
