describe "Mediator", ->
  describe 'fireEvent', ->
    a =
      x: ->
      y: ->
      z: ->

    it 'should fire event', ->
      spyOn a, 'x'
      Mediator.addListener 'test', a.x
      Mediator.fireEvent 'test', 'x'
      expect(a.x).toHaveBeenCalledWith('x')
      Mediator.removeListener 'test', a.x

    it 'should fire event to all listeners', ->
      spyOn a, 'x'
      spyOn a, 'y'
      spyOn a, 'z'
      Mediator.addListener 'test', a.x
      Mediator.addListener 'test', a.y
      Mediator.addListener 'test', a.z
      Mediator.fireEvent 'test', 'x'
      expect(a.x).toHaveBeenCalledWith('x')
      expect(a.y).toHaveBeenCalledWith('x')
      expect(a.z).toHaveBeenCalledWith('x')
      Mediator.removeListener 'test', a.x
      Mediator.removeListener 'test', a.z
      Mediator.removeListener 'test', a.y

  describe "addListener", ->
    x = ->
    it "should create *type* if not present", ->
      expect(Mediator.listeners.test).toBe undefined
      Mediator.addListener 'test', x
      expect(Mediator.listeners.test).not.toBe undefined
      Mediator.removeListener 'test', x
    it "should add callback to listeners", ->
      expect(Mediator.listeners.test).toBe undefined
      Mediator.addListener 'test', x
      expect(Mediator.listeners.test.length).toBe 1
      expect(Mediator.listeners.test).not.toBe undefined
      Mediator.removeListener 'test', x
  describe "removeListener", ->
    x = ->
    it "should delete *type* if no listeneres left", ->
      expect(Mediator.listeners.test).toBe undefined
      Mediator.addListener 'test', x
      expect(Mediator.listeners.test).not.toBe undefined
      Mediator.removeListener 'test', x
      expect(Mediator.listeners.test).toBe undefined