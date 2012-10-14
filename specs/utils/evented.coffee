describe "Event", ->
  describe 'constructor', ->
    it "should throw error on no target", ->
      a = ->
        new Crystal.Utils.Event()
      expect(a).toThrow()
    it "should throw error on invalid", ->
      a = ->
        new Crystal.Utils.Event('asd')
      expect(a).toThrow()
    it 'should create event', ->
      t = {}
      a = new Crystal.Utils.Event(t)
      expect(a instanceof Crystal.Utils.Event).toBe true
      expect(a.target).toBe t
      expect(a.cancelled).toBe false
  describe 'stop', ->
    it 'should set cancelled to true', ->
      a = new Crystal.Utils.Event({})
      expect(a.cancelled).toBe false
      a.stop()
      expect(a.cancelled).toBe true
describe "Evented", ->
  class Test extends Crystal.Utils.Evented
  a = new Test
  b =
    x: ->
    y: ->
  spy = spyOn b, 'x'
  spy2 = spyOn b, 'y'

  x = ->
  describe 'trigger', ->
    it 'should trigger an event', ->
      t = x: ->
      spyOn t, 'x'
      a.on 'test', t.x
      a.trigger 'test'
      expect(t.x).toHaveBeenCalled()
      a.off 'test', t.x
  describe 'on', ->
    it 'should add event listener', ->
      a.on 'test', x
      expect(a._mediator.listeners.test.first).toBe x
  describe 'off', ->
    it 'should remove event listener', ->
      a.off 'test', x
      expect(a._mediator.listeners.test).toBe undefined
  describe 'constructor', ->
    it "should create instance", ->
      expect(a instanceof Test).toBe true
      expect(a._mediator).not.toBe undefined
  describe 'toString', ->
    it "should return constructors name", ->
      expect(a.toString()).toBe '[Object Test]'
  describe 'subscribe', ->
    it "subsribe the instance to the event", ->
      a.subscribe 'test', spy
      expect(Mediator.listeners.test.first).toBe spy
    it "should recieve an event", ->
      c = new Test
      c.publish 'test'
      expect(spy).toHaveBeenCalled()
  describe 'publish', ->
    it "should publish an Event", ->
      a.subscribe 'test2', spy2
      a.publish 'test2'
      expect(spy2).toHaveBeenCalled()
      a.unsubscribe 'test2', spy2
  describe 'unsubscribe', ->
    it "should unsubscribe the instance from the event", ->
      a.unsubscribe 'test', spy
      expect(Mediator.listeners.test).toBe undefined