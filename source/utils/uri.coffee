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


