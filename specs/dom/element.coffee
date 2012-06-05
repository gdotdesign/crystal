define ['source/dom/element','source/dom/node-list','source/dom/document-fragment'], ->
  describe "Element.create", ->
    it "should create a arbitary element from tagname", ->
      e = Element.create 'div'
      expect(e instanceof HTMLElement).toBe true
    it "create a div element from classname", ->
      e = Element.create '.test'
      expect(e instanceof HTMLElement).toBe true
      expect(e.tagName).toBe 'DIV'
    it "should create a div element from id", ->
      e = Element.create '#test'
      expect(e instanceof HTMLElement).toBe true
      expect(e.tagName).toBe 'DIV'
    it "should add muiltiple type attributes", ->
      e = Element.create '.class1.class2'
      expect(e instanceof HTMLElement).toBe true
      expect(e.tagName).toBe 'DIV'
      expect(e.class).toBe 'class1 class2'
    it "should add muiltiple type attributes (merged)", ->
      e = Element.create '.class1.class2', {class: 'asd asd2'}
      expect(e instanceof HTMLElement).toBe true
      expect(e.tagName).toBe 'DIV'
      expect(e.class).toBe 'class1 class2 asd asd2'
    it "should add muiltiple type attributes (merged array)", ->
      e = Element.create '.class1.class2', {class: ['asd','asd2']}
      expect(e instanceof HTMLElement).toBe true
      expect(e.tagName).toBe 'DIV'
      expect(e.class).toBe 'class1 class2 asd asd2'
    it "should add uniq type attributes (last as priority)", ->
      e = Element.create '%text%text2'
      expect(e instanceof HTMLElement).toBe true
      expect(e.tagName).toBe 'DIV'
      expect(e.getAttribute('type')).toBe 'text2'
    it "should add uniq type attributes (atts as priority)", ->
      e = Element.create '%text', type: 'text2'
      expect(e instanceof HTMLElement).toBe true
      expect(e.tagName).toBe 'DIV'
      expect(e.getAttribute('type')).toBe 'text2'
    it "should return passed element", ->
      e = Element.create '%text', type: 'text2'
      e2 = Element.create e
      expect(e instanceof HTMLElement).toBe true
      expect(e).toBe e2
  describe "Node::append", ->
    it 'shoudl append an node as child', ->
      node = Element.create 'div'
      child = Element.create 'div'
      node.append child
      expect(node.contains child).toBe true
  describe "Node::empty", ->
    it 'should remove all child nodes', ->
      node = Element.create 'div'
      child = Element.create 'div'
      child2 = Element.create 'div'
      node.append child
      node.append child2
      node.empty()
      expect(node.contains child).toBe false
      expect(node.contains child2).toBe false