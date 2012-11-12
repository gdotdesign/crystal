# @requires ../types/function
# @requires ../types/array
# @requires ../types/string
# @requires ../types/object

# TODO Errors, FileUpload, Progress Events etc...
window.Response = class Utils.Response
  constructor: (headers,body,status) ->
    @headers = headers
    @raw = body
    @status = status

  isScript: -> @headers['Content-Type'] is 'text/javascript'
  isHtml: -> @headers['Content-Type'] is 'text/html'
  isXML: -> @headers['Content-Type'] is 'text/xml'
  isJSON: ->
    contentType = @headers['Content-Type']
    contentType is 'text/json' or contentType is 'application/json'

  @get 'body', ->
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

  request: (method = 'GET' , args...) ->
    args = args.compact()
    [data,callback] = args if args.length is 2
    [callback] = args if args.length is 1
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

  get:    (data,callback) -> @request 'GET', data, callback
  post:   (data,callback) -> @request 'POST', data, callback
  put:    (data,callback) -> @request 'PUT', data, callback
  delete: (data,callback) -> @request 'DELETE', data, callback
  patch:  (data,callback) -> @request 'PATCH', data, callback

