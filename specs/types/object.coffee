describe "Object", ->
  describe "pluck", ->
    it 'should return an array of properties of properties', ->
      a = 
        b: {x: 1}
        c: {x: 2}
      b = Object.pluck a, 'x'
      expect(b[0]).toBe 1
      expect(b[1]).toBe 2

  describe "values", ->
    it 'should return values of properties', ->
      a = {a: 1, b:2}
      b = Object.values a
      expect(b[0]).toBe 1
      expect(b[1]).toBe 2

  describe "each", ->
    it 'should iterate through own properties', ->
      a = {a: 1, b:2}
      b = {}
      Object.each a, (key,value) ->
        b[key] = value*2
      expect(b.a).toBe 2
      expect(b.b).toBe 4

  describe "toFormData", ->
    it 'should create FormData', ->
      a = {a: 1, b:2}
      b = a.toFormData()
      expect(b instanceof FormData).toBe true

  describe "toQueryString", ->
    it 'should create query string', ->
      a = {a: 1, b:2}
      b = a.toQueryString()
      expect(b).toBe "a=1&b=2"

  describe "canRespondTo", ->
    it 'should return true if it can respond to', ->
      a = 
        x: ->
      expect(Object.canRespondTo(a,'x')).toBe true
    it 'should return true if it can respond to multiple', ->
      a = 
        x: ->
        y: ->
      expect(Object.canRespondTo(a,'x','y')).toBe true
    it 'should return false for undefined', ->
      a = 
        x: ->
      expect(Object.canRespondTo(a,'y')).toBe false
    it 'should return false for non function', ->
      a = 
        x: ->
        y: 'asd'
      expect(Object.canRespondTo(a,'y')).toBe false
    it 'should return false for non function (multiple)', ->
      a = 
        x: ->
        y: 'asd'
      expect(Object.canRespondTo(a,'y','x')).toBe false