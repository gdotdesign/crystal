define ->
  Object.defineProperty Node::, 'context',
    set: (value) ->
      @templates = Array::slice.call @children
      @emtpy()
      if value instanceof Collection
        value.on 'add', (item) ->
          # add templates
        value.on 'remove'
          # remove tempates
        value.on 'change'
          # rearrange tempates