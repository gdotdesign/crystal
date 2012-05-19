define ->
  parseQueryString = (queryString) ->
    ret = {}
    regexp = /([^&=]+)=([^&]*)/g
    while match = regexp.exec(queryString)
      ret[decodeURIComponent(match[1])] = decodeURIComponent(match[2])
    ret
    
  toQueryString = (data) ->
    (for own key, value of data
      "#{key}=#{value.toString()}").join "&"
        
  class URI
    @parseQueryString: parseQueryString
    @toQueryString: toQueryString
    
    constructor: (uri = '') ->
      regexp = /(.+):\/\/(.+?)\/(.*)/
      if uri
        m = uri.toString().match regexp
        throw new URIError("Malformed URI!") unless m
      else
        m = window.location.toString().match regexp
      [full, protocol, domain, path] = m
      @host = domain.match(/.*(?=[:])/)?[0]
      @protocol = protocol or 'http'
      @port = parseInt(domain.match(/:(\d+)$/)?[1]) or 80
      @hash = path?.match(/#(.*)$/)?[1] or ''
      @query = parseQueryString(path.match(/\?(.*)(?=[#])/)?[1])
      @path = path?.match(/.*(?=[?])/)?[0] or ''
      
    toString: ->
      uri = @protocol
      uri += "://"+@host
      uri += ":"+@port unless @port is 80
      uri += "/"+@path if @path isnt ""
      uri += "?"+toQueryString(@query) if Object.keys(@query).length > 0
      uri += "#"+@hash if @hash isnt ""
      uri
          
    
