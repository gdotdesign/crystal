# @requires ../types/array
# @requires ../types/string
# @requires ../types/object

class Response
  constructor: (headers,body,status) ->
    @headers = headers
    @raw = body
    @status = status
    @body = switch @headers['Content-Type']
      when "text/html"
        div = document.createElement('div')
        div.innerHTML = body
        df = document.createDocumentFragment()
        for node in div.childNodes
          df.appendChild node
        df
      when "text/json", "application/json"
        JSON.parse(body)
      else
        body

types =
  script: ['text/javascript']
  html: ['text/html']
  JSON: ['text/json','application/json']
  XML: ['text/xml']

Object.each types, (key,value) ->
  Object.defineProperty Response::, 'is'+key.capitalize(), value: ->
    value.map( (type) => @headers['Content-Type'] is type).compact().length > 0

class Request
  constructor: (url, data = {}, headers = {}) ->
    @uri = url
    @headers = headers
    @data = data
    @_request = new XMLHttpRequest()
    @_request.onreadystatechange = @handleStateChange

  request: (method,data,callback) ->
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
  Request::[type] = (data, callback) ->
    @request type.toUpperCase(), data, callback

