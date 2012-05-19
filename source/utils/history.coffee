define ['./evented'], (evented) ->
  class History extends evented
    constructor: ->
      @_type = if 'pushState' of history then 'popstate' else 'hashchange'
      window.addEventListener @_type, (event) =>
        url = switch @_type
          when 'popstate'
            window.location.pathname
          when 'hashchange'
            window.location.hash
        @trigger 'change', url
      @stateid = 0
    push: (url) ->  
      switch @_type
        when 'popstate'
          history.pushState {}, @stateid++, url
        when 'hashchange'
          window.location.hash = url
        
