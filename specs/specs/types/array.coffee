define ['source/types/array'], ->
  describe "Array", ->
    it "all mutator method should return the array", ->
      a = []
      for key in ['_compact','_uniq','_pluck','_shuffle','_shift','_empty','_remove','_removeAll','_push']
        if key.match /^_/
          b = a[key]()
          expect(a).toBe b

    it 'each should be forEach', ->
      expect(Array::each).toBe Array::forEach
    it 'pluck should return an array of properties', ->
      a = [{prop:'c'},{prop:'d'}]
      b = a.pluck 'prop'
      b.each (value,index) ->
        expect(value).toBe a[index].prop
    it "uniq should remove all duplicates", ->
      a = [false, null, 'a', 'a', null, false]
      b = a.uniq()
      expect(b[0]).toBe false
      expect(b[1]).toBe null
      expect(b[2]).toBe 'a'
      expect(b.length).toBe 3

    it "uniq should remove all duplicates", ->
      a = [false, null, 'a', 'a', null, false]
      b = a.uniq()
      expect(b[0]).toBe false
      expect(b[1]).toBe null
      expect(b[2]).toBe 'a'
      expect(b.length).toBe 3

    it "compact sould remove all falsy values", ->
      a = [false, null, 'a']
      b = a.compact()
      expect(b[0]).toBe 'a'
      expect(b.length).toBe 1

    it 'remove should remove the first instance of the item', ->
      a = ['a','a','a']
      b = a.remove 'a'
      expect(b.length).toBe 2

    it 'empty mutator should empty the array', ->
      a = ['a','a','a']
      a._empty()
      expect(a.length).toBe 0

    it 'remove mutator should remove the first instance of the item modifing the array', ->
      a = ['a','a','a']
      a._remove 'a'
      expect(a.length).toBe 2
    
    it 'remveAll mutator should all instances of the item modifing the array', ->
      a = ['a','a','a']
      a._removeAll 'a'
      expect(a.length).toBe 0

    it 'pluck mutator should return an array of properties modifing the array', ->
      a = [{prop:'c'},{prop:'d'}]
      b = a.dup()
      a._pluck 'prop'
      a.each (value,index) ->
        expect(value).toBe b[index].prop

    it "uniq mutator sould remove all duplicates modifing the array", ->
      a = [false, null, 'a', 'a', null, false]
      a._uniq()
      expect(a[0]).toBe false
      expect(a[1]).toBe null
      expect(a[2]).toBe 'a'
      expect(a.length).toBe 3
      
    it "compact mutator sould remove all falsy values modifing the array", ->
      a = [false, null, 'a']
      a._compact()
      expect(a[0]).toBe 'a'
      expect(a.length).toBe 1
