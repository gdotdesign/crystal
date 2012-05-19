define ->
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

  DocumentFragment.create = ->
    document.createDocumentFragment()
    
  DocumentFragment
