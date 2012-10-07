describe "Unit", ->
  describe 'constructor', ->
    it 'should create unit', ->
      u = new Unit
      expect(u.px).toBe '0px'
    it 'should create unit with base pixel size', ->
      u = new Unit '0px', 24
      expect(u.px).toBe '0px'
      expect(u.base).toBe 24

  describe 'set', ->
    it 'set the value in pixels', ->
      u = new Unit
      u.set '10px'
      expect(u.px).toBe '10px'
    it 'set the value in em', ->
      u = new Unit
      u.set '1em'
      expect(u.px).toBe '16px'

  describe 'px', ->
    it 'should return value in pixels', ->
      u = new Unit
      u.set '1em'
      expect(u.px).toBe '16px'

  describe 'em', ->
    it 'should return value in em', ->
      u = new Unit
      u.set '8px'
      expect(u.em).toBe '0.5em'