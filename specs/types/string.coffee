define ['source/types/string'], ->
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
        expect(a.hyphenate()).toBe '-i-like-cookies'
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