describe "Array", ->
  describe "pluck", ->
    it 'should return an array of properties', ->
      a = [{prop:'c'},{prop:'d'}]
      b = a.pluck 'prop'
      b.forEach (value,index) ->
        expect(value).toBe a[index].prop

  describe "uniq", ->
    it "should remove all duplicates", ->
      a = [false, null, 'a', 'a', null, false]
      b = a.uniq()
      expect(b[0]).toBe false
      expect(b[1]).toBe null
      expect(b[2]).toBe 'a'
      expect(b.length).toBe 3

  describe "compact", ->
    it "should remove all falsy values", ->
      a = [false, null, 'a']
      b = a.compact()
      expect(b[0]).toBe 'a'
      expect(b.length).toBe 1
  
  describe "remove", ->
    it 'should remove the first instance of the item', ->
      a = ['a','a','a']
      b = a.remove 'a'
      expect(b.length).toBe 2

  describe "removeAll", ->
    it 'should remove all instances of the item', ->
      a = ['a','a','a']
      b = a.removeAll 'a'
      expect(b.length).toBe 0

  describe "shuffle", ->
    it 'should shuffle the array (indexes must not be the same)', ->
      a = [0..10000]
      b = a.shuffle()
      shuffled = false
      for item, i in a
        if b[i] isnt item
          shuffled = true
      expect(shuffled).toBe true

  describe "shuffle", ->
    it 'should shuffle the array (indexes must not be the same)', ->
      a = [0..10000]
      b = a.shuffle()
      shuffled = false
      for item, i in a
        if b[i] isnt item
          shuffled = true
      expect(shuffled).toBe true

  describe "dup", ->
    it 'should duplicate the array', ->
      a = ['a','b','c','d']
      b = a.dup()
      same = true
      for item, i in a
        if b[i] isnt item
          same = false
      expect(same).toBe true

  describe "include", ->
    it 'should return true if the item is in the array', ->
      a = ['a','b','c','d']
      expect(a.include('a')).toBe true
    it 'should return false if the item is not in the array', ->
      a = ['a','b','c','d']
      expect(a.include('x')).toBe false

  describe "first", ->
    it 'should return the first item', ->
      obj = {a:'x'} 
      a = [obj,'b','c','d']
      expect(a.first).toBe obj
  
  describe "first", ->
    it 'should return the last item', ->
      obj = {a:'x'} 
      a = ['b','c','d',obj]
      expect(a.last).toBe obj

  describe "sample", ->
    it 'should return the random item', ->
      a = ['b','c','d','a']
      expect(a.include(a.sample)).toBe true