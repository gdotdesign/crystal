define ['source/dom/element','source/dom/node-list','source/dom/document-fragment'], ->
  beforeEach ->
    @d = DocumentFragment.create()
    
  describe "DocumentFragment", ->
    it "DocumentFragment.create should create a DocumentFragment", ->
      expect(@d instanceof DocumentFragment).toBe true
    it "children property should return NodeList", ->
      expect(@d.children instanceof NodeList).toBe true
    it "remove should remove an element from the DocumentFragment", ->
      e = Element.create 'div'
      @d.append e
      expect(@d.children.include e).toBe true
      @d.remove e
      expect(@d.children.include e).toBe false
