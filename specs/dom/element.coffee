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
    it "should create attributes for css attribute expression", ->
      e = Element.create("[type=text]")
      expect(e instanceof HTMLElement).toBe true
      expect(e.getAttribute('type')).toBe 'text'
    it "should create attributes for css attribute expression (no value)", ->
      e = Element.create("[type]")
      expect(e instanceof HTMLElement).toBe true
      expect(e.getAttribute('type')).toBe 'true'
    it "should remove not valid characters form end tagname", ->
      e = Element.create("!%/~'")
      expect(e instanceof HTMLElement).toBe true
