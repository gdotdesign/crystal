describe "String", ->
  describe "indent", ->
    it "should indent", ->
      a = "a\nb"
      expect(a.indent(2)).toBe '  a\n  b'
  describe "outdent", ->
    it "should outdent", ->
      a = "  a\n  b"
      expect(a.outdent(2)).toBe 'a\nb'
  describe "hypenate", ->
    it "should hypenate", ->
      a = "ILikeCookies"
      expect(a.hyphenate()).toBe 'i-like-cookies'
  describe "camelCase", ->
    it "should camelCase", ->
      a = "I-like-cookies"
      expect(a.camelCase()).toBe 'ILikeCookies'
  describe "capitalize", ->
    it "should capitalize", ->
      a = "i like cookies"
      expect(a.capitalize()).toBe 'I Like Cookies'
  describe "compact", ->
    it "should remove extra whitespace", ->
      a = ' i      like     cookies      \n\n'
      expect(a.compact()).toBe 'i like cookies'
  describe "entities", ->
    it "should convert entities", ->
      a = '&<>"'
      expect(a.entities()).toBe '&amp;&lt;&gt;&quot;'
  describe "Random", ->
    it "should return random string", ->
      a = String.random(10)
      expect(a.length).toBe 10
      expect(typeof a).toBe 'string'
      expect(a.toString()).toBe a
  describe "test", ->
    it "should return true if match", ->
      a = 'Luke is awesome'.test /Luke/
      expect(a).toBe true
    it "should return false if not match", ->
      a = 'Luke is awesome'.test /Leia/
      expect(a).toBe false
  describe 'escape', ->
    it "should escape regexp specials", ->
      for item in '-[]{}()*+?./\\^$|#'.split('')
        expect(item.escape()).toBe '\\'+item
  describe 'ellipsis', ->
    it "should trim longer strings and add ...", ->
      a = 'Luke is awesome'
      expect(a.ellipsis(4)).toBe 'Luke...'
    it "should return string if not longer then length", ->
      a = 'Luke is awesome'
      expect(a.ellipsis(20)).toBe a
  describe 'parseQueryString', ->
    it "should return empty object for wrong string", ->
      a = 'Luke is awesome'
      expect(Object.keys(a.parseQueryString()).length).toBe 0
    it "should parse string if valid", ->
      a = 'a=0&b=1'
      b = a.parseQueryString()
      expect(b.a).toBe '0'
      expect(b.b).toBe '1'
  describe 'wordWrap', ->
    it "should wrap", ->
      a = 'Luke is awesome'
      b = 'Luke is :awesome'
      expect(a.wordWrap(7,':')).toBe b
