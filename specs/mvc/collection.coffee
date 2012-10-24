xdescribe 'Collection', ->
  describe 'constructor', ->
    it 'should have a length', ->
      c = new Collection()
      expect(c.length).not.toBe undefined
    it 'should add arguments as elements in order', ->
      c = new Collection 'a', 'b', 'c'
      expect(c[0]).toBe 'a'
      expect(c[1]).toBe 'b'
      expect(c[2]).toBe 'c'
  describe 'push', ->
    it 'should add item to the end', ->
      c = new Collection
      c.push 'a'
      expect(c[c.length-1]).toBe 'a'
    it 'should trigger add event with item', ->
      c = new Collection
      runs =>
        c.on 'add', (e, item) =>
          @added = true
          @item = item
        c.push 'a'
      waitsFor =>
        !!@added
      , 2000
      runs =>
        expect(@item).toBe 0
