describe "NodeList", ->
  beforeEach ->
    a = Element.create 'div.nodelist'
    b = Element.create 'p.nodelist'
    @els = [a,b]
    document.body.append a, b
    @nl = document.querySelectorAll '.nodelist'

  afterEach ->
    @els.forEach (el) -> el.dispose()

  describe "forEach", ->
    it 'should iterate through the elements', ->
      expect(@nl instanceof NodeList).toBe true
      @nl.forEach (el,i) =>
        expect(el instanceof Element).toBe true
        expect(@els[i]).toBe el
  describe "map", ->
    it 'should map all elements', ->
      mapped = @nl.map (el) ->
        el.tag
      expect(mapped).toEqual ['div','p']
  describe "pluck", ->
    it 'should get properties of all elements', ->
      mapped = @nl.pluck 'tag'
      expect(mapped).toEqual ['div','p']
  describe "include", ->
    it 'should return if the given element is in the collection', ->
      expect(@nl.include(@els[0])).toBe true
    it 'should return false the given element is not in the collection', ->
      expect(@nl.include(document.body)).toBe false
  describe "first", ->
    it 'should return the first element from the collection', ->
      expect(@nl.first).toBe @els[0]
  describe "last", ->
    it 'should return the last element from the collection', ->
      expect(@nl.last).toBe @els[1]
  describe "_wrap", ->
    it 'should call fn on all childnodes', ->
      @i = 0
      a =
        x: => @i++
      Object.defineProperty NodeList::, "testFN", value: NodeList._wrap a.x
      @nl.testFN()
      expect(@i).toBe 2