define ['./uri','../types/array'], (URI) ->
  # TODO stuff like chaining, method override etc...
  class Response
    constructor: (headers,body,status) ->
      @headers = headers
      @body = body
      @status = status

  class Request
    constructor: (url,data = {},headers = []) ->
      @uri = new URI url
      @headers = headers
      @data = data
      @_request = new XMLHttpRequest()
      @_request.onreadystatechange = @handleStateChange
      
    request: (method,callback) ->
      if (@_request.status is 4) or (@_request.status is 0)
        @_request.open(@method,@uri)
        for own key, value of @headers
          @_request.setRequestHeader key.toString(), value.toString()
        @_callback = callback
        @_request.send()
      
    handleStateChange: =>
      if @_request.readyState is 4
        headers = @_request.getAllResponseHeaders().split(/\n/).compact()
        body = @_request.response
        status = @_request.status
        @_callback new Response(headers,body,status)
        @_request.responseText
        
  ['get','post','put','delete','patch'].forEach (type) ->
    Request::[type] = (callback) ->
      @request type.toUpperCase(), callback

  Request

