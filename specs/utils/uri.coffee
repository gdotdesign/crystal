describe 'URI', ->
  cases = [
    ['http://host']
    ['https://host.com']
    ['http://subdomain.host.com']
    ['http://host.com:81']
    ['ftp://host.com:81']
    ['http://host.com:81?query=a']
    ['http://host.com:81/?query=a','http://host.com:81?query=a']
    ['http://host.com:81/?query','http://host.com:81']
    ['http://host.com:81/#anchor','http://host.com:81#anchor']
    ['http://host.com:81/directory/?query=a#anchor']
    ['http://host.com:81/directory?query=a#anchor']
    ['http://user:pass@host.com:81/#anchor','http://user:pass@host.com:81#anchor']
    ['http://user:pass@host.com:81/file.ext']
    ['http://user:pass@host.com:81/directory/']
    ['http://user:pass@host.com:81/directory/?query=a']
    ['http://user:pass@host.com:81/directory/#anchor']
    ['http://user:pass@host.com:81/directory/sub.directory/']
    ['http://user:pass@host.com:81/directory/sub.directory/file.ext']
    ['http://user:pass@host.com:81/directory/file.ext?query=a']
    ['http://user:pass@host.com:81/directory/file.ext?query=1&test=2']
    ['http://user:pass@host.com:81/directory/file.ext?query=1#anchor']
  ]
  cases.forEach (test)->
    it "should parse and return '#{test}'", ->
      uri = new URI(test[0])
      expect(uri.toString()).toBe test[1] or test[0]