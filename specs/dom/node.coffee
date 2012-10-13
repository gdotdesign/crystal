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
  describe "all", ->
    it "should return all childnodes", ->
      node = Element.create 'div'
      child = Element.create 'div'
      input = Element.create 'input'
      node.append child, input
      expect(node.all().length).toBe 2
    it "should return all childnodes given a specified selector", ->
      node = Element.create 'div'
      child = Element.create 'div'
      input = Element.create 'input'
      node.append child, input
      expect(node.all("input").length).toBe 1
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
  describe "moveUp", ->
    it 'should not move element if there is no previous sibling', ->
      parent = Element.create()
      node = Element.create()
      parent.append node
      node.moveUp()
      expect(parent.contains node).toBe true
    it 'should move element up', ->
      parent = Element.create()
      node = Element.create()
      node2 = Element.create()
      parent.append node2, node
      expect(parent.first()).toBe node2
      node.moveUp()
      expect(parent.first()).toBe node
  describe "moveDown", ->
    it 'should not move element if there is no previous sibling', ->
      parent = Element.create()
      node = Element.create()
      parent.append node
      node.moveDown()
      expect(parent.contains node).toBe true
    it 'should move element down', ->
      parent = Element.create()
      node = Element.create()
      node2 = Element.create()
      parent.append node, node2
      expect(parent.first()).toBe node
      node.moveDown()
      expect(parent.first()).toBe node2
      expect(parent.last()).toBe node
  describe "delegateEventListener", ->
    it "should delegate events", ->
      window.fireEvent = (el,target) ->
        evt = document.createEvent("MouseEvents")
        evt.initMouseEvent('click', true, true, el.ownerDocument.defaultView, 1,0,0,0,0,false,false,false,false,0,target)
        el.dispatchEvent(evt)
      @x = 0
      @y = 0
      a =
        x: => @x++
        y: => @y++
      parent = Element.create()
      node1 = Element.create("a.link")
      node2 = Element.create("a")
      parent.append node1, node2
      parent.delegateEventListener 'click:a.link', a.x
      parent.delegateEventListener 'click:a', a.y
      fireEvent parent, node2
      expect(@x).toBe 0
      expect(@y).toBe 1
      fireEvent parent, node1
      expect(@x).toBe 1
      expect(@y).toBe 2

  for alias in ['addEvent','delegateEvent','removeEvent']
    describe alias, ->
      it "should be alias of #{alias}Listener", ->
        expect(Node::[alias]).toBe Node::[alias+"Listener"]