define ['source/types/array'], ->
  describe "Array", ->
    it "all mutator method should return the array", ->
      a = []
      for key in ['_compact','_uniq','_pluck','_shuffle','_shift','_empty','_remove','_removeAll','_push']
        if key.match /^_/
          b = a[key]()
          expect(a).toBe b
          
    describe "each", ->
      it 'should be forEach', ->
        expect(Array::each).toBe Array::forEach

    describe "pluck", ->
      it 'should return an array of properties', ->
        a = [{prop:'c'},{prop:'d'}]
        b = a.pluck 'prop'
        b.each (value,index) ->
          expect(value).toBe a[index].prop
      it 'should return an array of properties modifing the array (mutator)', ->
        a = [{prop:'c'},{prop:'d'}]
        b = a.dup()
        a._pluck 'prop'
        a.each (value,index) ->
          expect(value).toBe b[index].prop

    describe "uniq", ->
      it "should remove all duplicates", ->
        a = [false, null, 'a', 'a', null, false]
        b = a.uniq()
        expect(b[0]).toBe false
        expect(b[1]).toBe null
        expect(b[2]).toBe 'a'
        expect(b.length).toBe 3
      it "should remove all duplicates modifing the array (mutator)", ->
        a = [false, null, 'a', 'a', null, false]
        a._uniq()
        expect(a[0]).toBe false
        expect(a[1]).toBe null
        expect(a[2]).toBe 'a'
        expect(a.length).toBe 3

    describe "compact", ->
      it "should remove all falsy values", ->
        a = [false, null, 'a']
        b = a.compact()
        expect(b[0]).toBe 'a'
        expect(b.length).toBe 1
      it "should remove all falsy values modifing the array (mutator)", ->
        a = [false, null, 'a']
        a._compact()
        expect(a[0]).toBe 'a'
        expect(a.length).toBe 1
    
    describe "remove", ->
      it 'should remove the first instance of the item', ->
        a = ['a','a','a']
        b = a.remove 'a'
        expect(b.length).toBe 2
      it 'should remove the first instance of the item modifing the array (mutator)', ->
        a = ['a','a','a']
        a._remove 'a'
        expect(a.length).toBe 2

    describe "empty", ->
      it 'empty mutator should empty the array', ->
        a = ['a','a','a']
        a._empty()
        expect(a.length).toBe 0

    describe 'removeAll', ->  
      it 'should all instances of the item modifing the array', ->
        a = ['a','a','a']
        a._removeAll 'a'
        expect(a.length).toBe 0


