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