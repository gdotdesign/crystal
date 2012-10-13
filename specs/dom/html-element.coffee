describe 'HTMLSelectElement', ->
  describe 'selectedOption', ->
    select = Element.create "select"
    for op in ['one','two','three']
      select.append Element.create "option[value=#{op}]"
    it 'should get selected option', ->
      expect(select.selectedOption).toBe select.first()
    it 'should set selected option by element', ->
      select.selectedOption = select.last()
      expect(select.selectedOption).toBe select.last()
describe 'HTMLInputElement', ->
  describe 'caretToEnd', ->
    it "should set caret to end", ->
      inp = Element.create 'input[value=test]'
      document.body.append inp
      expect(inp.selectionStart).toBe 0
      expect(inp.selectionEnd).toBe 0
      inp.focus()
      inp.caretToEnd()
      expect(inp.selectionStart).toBe 4
      expect(inp.selectionEnd).toBe 4
      inp.dispose()
describe 'HTMLElement', ->
  describe "css", ->
    it "should return computedStyle", ->
      node = Element.create 'div'
      expect(node.css('width')).toBe ''
    it "should return computedStyle for inline", ->
      node = Element.create 'div[style=width:10px;]'
      document.body.append node
      expect(node.css('width')).toBe '10px'
      node.dispose()
    it "should set style", ->
      node = Element.create 'div'
      node.css 'width', '100px'
      expect(node.getAttribute('style').trim()).toBe 'width: 100px;'
      document.body.append node
      expect(node.css('width')).toBe '100px'
      node.dispose()
  describe "dispose", ->
    it 'should remove the element', ->
      node = Element.create 'div'
      child = Element.create 'div'
      node.append child
      expect(node.contains child).toBe true
      child.dispose()
      expect(node.contains child).toBe false
  describe "ancestor", ->
    it 'should get the ancestor of the element', ->
      node = Element.create 'div'
      child = Element.create 'div'
      node.append child
      expect(child.ancestor()).toBe node
    it 'should get the ancestor of the element deep', ->
      ancestor = Element.create 'div.ancestor'
      node = Element.create 'div'
      ancestor.append node
      child = Element.create 'div'
      node.append child
      expect(child.ancestor(".ancestor")).toBe ancestor
  describe "next", ->
    it 'should get the next sibling of the element', ->
      node = Element.create 'div'
      child = Element.create 'div'
      child2 = Element.create 'div'
      node.append child, child2
      expect(child.next()).toBe child2
    it 'should get the next sibling of the element deep', ->
      node = Element.create 'div'
      child = Element.create 'div'
      child2 = Element.create 'div'
      child3 = Element.create 'a'
      node.append child, child2, child3
      expect(child.next("a")).toBe child3
  describe "prev", ->
    it 'should get the prev sibling of the element', ->
      node = Element.create 'div'
      child = Element.create 'div'
      child2 = Element.create 'div'
      node.append child2, child
      expect(child.prev()).toBe child2
    it 'should get the prev sibling of the element deep', ->
      node = Element.create 'div'
      child = Element.create 'div'
      child2 = Element.create 'div'
      child3 = Element.create 'a'
      node.append child3, child2, child
      expect(child.prev("a")).toBe child3
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