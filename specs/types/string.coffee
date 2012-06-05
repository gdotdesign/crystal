define ['source/types/string'], ->
  describe "String", ->
    it "should indent", ->
      a = "a\nb"
      expect(a.indent(2)).toBe '  a\n  b'
    it "should outdent", ->
      a = "  a\n  b"
      expect(a.outdent(2)).toBe 'a\nb'
    it "should hypenate", ->
      a = "ILikeCookies"
      expect(a.hyphenate()).toBe '-i-like-cookies'
    it "should camelCase", ->
      a = "I-like-cookies"
      expect(a.camelCase()).toBe 'ILikeCookies'
    it "should capitalize", ->
      a = "i like cookies"
      expect(a.capitalize()).toBe 'I Like Cookies'
    it "clean should remove extra whitespace", ->
      a = ' i      like     cookies      \n\n'
      expect(a.clean()).toBe 'i like cookies'
    it "should convert entities", ->
      a = '&<>"'
      expect(a.entities()).toBe '&amp;&lt;&gt;&quot;'