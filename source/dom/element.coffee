define ['../types/object','../types/array'], ->
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

  prefixes = Object.pluck(Attributes,'prefix')._push("$").join("|")
  Object.each Attributes, (key,value) ->
    value.regexp = new RegExp value.prefix+"(.*?)(?=#{prefixes})", "g"
    
  # Utility Functions
  _wrap = (fn) ->
    (args...) ->
      for el in @
        fn.apply el, args
      @

  _matchesSelector = (el, selector) ->
    if el.webkitMatchesSelector
      el.webkitMatchesSelector selector
    else if el.mozMatchesSelector
      el.mozMatchesSelector selector
    else
      document.querySelectorAll(selector).include el

  _find = (property, selector, el) ->
    elements = document.querySelectorAll selector
    while el = el[property]
      if el instanceof Element
        if elements.include el
          return el

  # Parse attributes from string (#id.class!title)  
  _parseName = (name) ->
    ret = 
      tag: name.match(new RegExp("^.*?(?=#{prefixes})"))[0] or 'div'
      attributes: {}
    Object.each Attributes, (key,value) ->
      if (m = name.match(value.regexp)) isnt null 
        name = name.replace(value.regexp, "")
        if value.unique
          ret.attributes[key] = m.pop().slice(1)
        else
          map = m.map (item) -> item.slice(1)
          ret.attributes[key] = map.join(" ")
    ret 

  # Methods for Node
  methods_node = 
    append: (elements...) ->
      for el in elements
        @appendChild el
    first: (selector = "*") ->
      @querySelector selector
    last: (selector = "*") ->
      @querySelectorAll(selector).last()
    all: (selector = "*") ->
      @querySelectorAll(selector)
    empty: ->
      @all().dispose()
      
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
      if @children
        @children[@selectedIndex]
    set: (el) ->
      if @chidren.include(el)
        @selectedIndex = @children.indexOf el

  Object.defineProperties HTMLElement::,
    tag: ->
      get: ->
        @tagName.toLowercase()
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

  Object.defineProperty Node::, 'delegateEventListener', value: (event,listener,useCapture) ->
    [baseEvent,selector] = event.split(':')
    @addEventListener baseEvent, (e) ->
      if _matchesSelector e.target, selector
        listener e

  ['addEventListener','removeEventListener','delegateEventListener'].each (prop) ->
    Object.defineProperty Node::, prop.replace("Listener",''), value: Node::[prop]
    Object.defineProperty window, prop.replace("Listener",''), value: window[prop]
    
  Element.create = (node, atts = {}) ->
    switch typeof node
      when 'element'
        node = element
      when 'string'
        {tag,attributes} = _parseName node
        node = document.createElement tag
        for key, value of attributes
          node.setAttribute key, value
    for key, value of atts
      if node[key] != undefined
        node[key] = value
      else
        node.setAttribute key, value
    node

  Node
