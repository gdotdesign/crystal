
describe "DocumentFragment", ->
  beforeEach ->
    @d = DocumentFragment.Create()
  describe "Create", ->
    it "should create a DocumentFragment", ->
      expect(@d instanceof DocumentFragment).toBe true
  describe 'children', ->
    it "should return NodeList", ->
      expect(@d.children instanceof NodeList).toBe true
  describe 'remove', ->
    it "should remove an element from the DocumentFragment", ->
      e = Element.create 'div'
      @d.append e
      expect(@d.children.include e).toBe true
      @d.remove e
      expect(@d.children.include e).toBe false
