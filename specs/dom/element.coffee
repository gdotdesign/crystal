describe "Element", ->
  describe "create", ->
    it "should create a new div element", ->
      div = Element.create("div")
      expect(div.tagName.toLowerCase()).toEqual "div"
      expect(not div.className and div.className.length is 0).toBeTruthy()
      expect(not div.id and div.id.length is 0).toBeTruthy()

    it "should create a new element with id and class", ->
      p = Element.create("p",
        id: "myParagraph"
        class: "test className"
      )
      expect(p.tagName.toLowerCase()).toEqual "p"
      expect(p.className).toEqual "test className"

    it "should create a new element with id and class from css expression", ->
      p = Element.create("p#myParagraph.test.className")
      expect(p.tagName.toLowerCase()).toEqual "p"
      expect(p.className).toEqual "test className"

    it "should not reset attributes and classes with null", ->
      div = Element.create("div#myDiv.myClass",
        id: null
        class: null
      )
      expect(div.tagName.toLowerCase()).toEqual "div"
      expect(div.id).toEqual "myDiv"
      expect(div.className).toEqual "myClass"

    it "should not reset attributes and classes with undefined", ->
      div = Element.create("div#myDiv.myClass",
        id: `undefined`
        class: `undefined`
      )
      expect(div.tagName.toLowerCase()).toEqual "div"
      expect(div.id).toEqual "myDiv"
      expect(div.className).toEqual "myClass"

    it "should fall back to a div tag", ->
      someElement = Element.create("#myId")
      expect(someElement.tagName.toLowerCase()).toEqual "div"
      expect(someElement.id).toEqual "myId"
    it "should create a arbitary element from tagname", ->
      e = Element.create 'div'
      expect(e instanceof HTMLElement).toBe true
    it "should create a div element from class name", ->
      e = Element.create '.test'
      expect(e instanceof HTMLElement).toBe true
      expect(e.tagName).toBe 'DIV'
    it "should create a div element from id", ->
      e = Element.create '#test'
      expect(e instanceof HTMLElement).toBe true
      expect(e.tagName).toBe 'DIV'
    it "should add multiple type attributes", ->
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

describe 'Node', ->
  describe "first", ->
    it 'should return first element if no selector is specifed', ->
      node = Element.create 'div'
      child = Element.create 'div'
      node.append child
      expect(node.first()).toBe child
    it 'should return first element metching the sepecifed selector', ->
      node = Element.create 'div'
      child = Element.create 'div'
      input = Element.create 'input'
      node.append child
      node.append input
      expect(node.first('input')).toBe input
  describe "last", ->
    it 'should return last element if no selector is specifed', ->
      node = Element.create 'div'
      child = Element.create 'div'
      node.append child
      expect(node.last()).toBe child
    it 'should return first element metching the sepecifed selector', ->
      node = Element.create 'div'
      child = Element.create 'div'
      input = Element.create 'input'
      node.append child
      node.append input
      expect(node.last('div')).toBe child
  describe "append", ->
    it 'should append an node as child', ->
      node = Element.create 'div'
      child = Element.create 'div'
      node.append child
      expect(node.contains child).toBe true
    it 'should append multiple nodes as child', ->
      node = Element.create 'div'
      child = Element.create 'div'
      child1 = Element.create 'div'
      child2 = Element.create 'div'
      node.append child1, child2, child
      expect(node.contains child).toBe true
      expect(node.contains child1).toBe true
      expect(node.contains child2).toBe true
    it 'should check arguments', ->
      node = Element.create 'div'
      child = 'test'
      a = ->
        node.append child
      expect(a).not.toThrow()
      child = null
      a = ->
        node.append child
      expect(a).not.toThrow()
  describe "empty", ->
    it 'should remove all child nodes', ->
      node = Element.create 'div'
      child = Element.create 'div'
      child2 = Element.create 'div'
      node.append child
      node.append child2
      node.empty()
      expect(node.contains child).toBe false
      expect(node.contains child2).toBe false


describe 'HTMLElement', ->
  describe "text", ->
    it 'should return the textContent of the element', ->
      node = Element.create 'div'
      node.textContent = 'asd'
      expect(node.text).toBe 'asd'
    it 'should set the textContent of the element', ->
      node = Element.create 'div'
      node.text = 'asd'
      expect(node.textContent).toBe 'asd'
  describe "html", ->
    it 'should return the innerHTML of the element', ->
      node = Element.create 'div'
      node.innerHTML = 'asd'
      expect(node.html).toBe 'asd'
    it 'should set the innerHTML of the element', ->
      node = Element.create 'div'
      node.html = 'asd'
      expect(node.innerHTML).toBe 'asd'
  describe "tag", ->
    it 'should return the tagName of the element (lowercase)', ->
      node = Element.create 'div'
      expect(node.tag).toBe 'div'
  describe "class", ->
    it 'should return the class attribute of the element (lowercase)', ->
      node = Element.create '.class1'
      expect(node.class).toBe 'class1'
  describe "parent", ->
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