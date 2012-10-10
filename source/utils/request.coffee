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

