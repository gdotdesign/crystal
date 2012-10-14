describe "Mediator", ->
  describe 'fireEvent', ->
    a =
      x: ->
      y: ->
      z: ->

    it 'should fire cancelled event', ->
      b =
        x: (e) -> e.stop()
        y: ->

      spyOn b, 'x'
      spyOn b, 'y'
      event = new Crystal.Utils.Event b
      Mediator.addListener 'cancel', b.x
      Mediator.fireEvent 'cancel', [event]
      expect(b.x).toHaveBeenCalled()
      expect(b.y).not.toHaveBeenCalled()

    it 'should fire event', ->
      spyOn a, 'x'
      event = new Crystal.Utils.Event a
      Mediator.addListener 'test', a.x
      Mediator.fireEvent 'test', [event,'x']
      expect(a.x).toHaveBeenCalledWith(event,'x')
      Mediator.removeListener 'test', a.x

    it 'should fire event to all listeners', ->
      spyOn a, 'x'
      spyOn a, 'y'
      spyOn a, 'z'
      event = new Crystal.Utils.Event a
      Mediator.addListener 'test', a.x
      Mediator.addListener 'test', a.y
      Mediator.addListener 'test', a.z
      Mediator.fireEvent 'test', [event,'x']
      expect(a.x).toHaveBeenCalledWith(event,'x')
      expect(a.y).toHaveBeenCalledWith(event,'x')
      expect(a.z).toHaveBeenCalledWith(event,'x')
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
    it "should throw error if not valid callback specified", ->
      a = ->
        Mediator.addListener 'test', 'bc'
      expect(a).toThrow()
  describe "removeListener", ->
    x = ->
    it "should delete *type* if no listeneres left", ->
      expect(Mediator.listeners.test).toBe undefined
      Mediator.addListener 'test', x
      expect(Mediator.listeners.test).not.toBe undefined
      Mediator.removeListener 'test', x
      expect(Mediator.listeners.test).toBe undefined