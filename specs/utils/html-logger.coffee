describe 'HTMLLogger', ->
  describe 'new', ->
    it 'should throw exception when the base element isnt HTMLElement', ->
      expect( -> new HTMLLogger(0)).toThrow()
  describe 'methods', ->
    it 'should append to base element', ->
      logger = new HTMLLogger(document.body)
      el = logger.debug 'Hello'
      expect(el.parent).toBe document.body
      el.dispose()
  ['debug', 'error', 'fatal', 'info', 'warn','log'].forEach (type)->
    describe type, ->
      it "should add #{type} class", ->
        logger = new HTMLLogger(document.body)
        el = logger[type] 'Hello'
        expect(el.parent).toBe document.body
        expect(el.class).toBe type
        el.dispose()