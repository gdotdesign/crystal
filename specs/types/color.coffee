define ['source/types/color'], (Color) ->
  describe "Color", ->
    it 'default value should be FFFFFF', ->
      c = new Color
      expect(c.hex).toBe "FFFFFF"
      expect(c.red).toBe 255
      expect(c.blue).toBe 255
      expect(c.green).toBe 255
      expect(c.hue).toBe 0
      expect(c.saturation).toBe 0
      expect(c.lightness).toBe 100
    describe 'hex', ->
      it 'should set hex value', ->
        c = new Color
        c.hex = "000000"
        expect(c.hex).toBe "000000"
        expect(c.red).toBe 0
        expect(c.blue).toBe 0
        expect(c.green).toBe 0
        expect(c.hue).toBe 0
        expect(c.saturation).toBe 0
        expect(c.lightness).toBe 0
