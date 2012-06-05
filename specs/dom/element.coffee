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
    it "should create a div when no arguments passed", ->
      e = Element.create()
      expect(e instanceof HTMLElement).toBe true
      expect(e.tag).toBe 'div'
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

  describe "HTMLElement::text", ->
    it 'should return the textContent of the element', ->
      node = Element.create 'div'
      node.textContent = 'asd'
      expect(node.text).toBe 'asd'
    it 'should set the textContent of the element', ->
      node = Element.create 'div'
      node.text = 'asd'
      expect(node.textContent).toBe 'asd'
  describe "HTMLElement::html", ->
    it 'should return the innerHTML of the element', ->
      node = Element.create 'div'
      node.innerHTML = 'asd'
      expect(node.html).toBe 'asd'
    it 'should set the innerHTML of the element', ->
      node = Element.create 'div'
      node.html = 'asd'
      expect(node.innerHTML).toBe 'asd'
  describe "HTMLElement::tag", ->
    it 'should return the tagName of the element (lowercase)', ->
      node = Element.create 'div'
      expect(node.tag).toBe 'div'
  describe "HTMLElement::tag", ->
    it 'should return the clas attribute of the element (lowercase)', ->
      node = Element.create '.class1'
      expect(node.class).toBe 'class1'
  describe "HTMLElement::parent", ->
    it 'should return the parent node of the element', ->
      node = Element.create 'div'
      document.body.append node
      expect(node.parent).toBe document.body
    it 'should set the parent node of the element', ->
      node = Element.create 'div'
      expect(node.parent).toBe null
      parent = Element.create 'div'
      parent.append node
      expect(node.parent).toBe parent