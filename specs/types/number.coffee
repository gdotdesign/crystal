describe "Number", ->
  describe 'clamp', ->
    it 'should retrun min if the number is lesser then min', ->
      expect((10).clamp(20,30)).toBe 20
    it 'should retrun max if the number is grater then max', ->
      expect((40).clamp(20,30)).toBe 30
    it 'should retrun number if the number is between min and max', ->
      expect((10).clamp(20,30)).toBe 20
  describe 'clampRange', ->
    it 'clampRange should retrun modulus if the number is grater then max', ->
      expect((40).clampRange(20,30)).toBe 10
    it 'clampRange should retrun modulus if the number is lower then min', ->
      expect((10).clampRange(20,30)).toBe 20
    it 'clampRange should retrun number if the number is between min and max', ->
      expect((25).clampRange(20,30)).toBe 25
  describe "upto", ->
    it 'should iterate up to number', ->
      i = 0
      (0).upto 10, (j) ->
        i = j
      expect(i).toBe 10
  describe "downto", ->
    it 'should iterate down to number', ->
      i = 0
      (20).downto 10, (j) ->
        i = j
      expect(i).toBe 10
  describe "times", ->
    it 'should iterate number times', ->
      i = 0
      (10).times (j) ->
        i = j
      expect(i).toBe 10
  describe "seconds", ->
    it 'should convert number to seconds', ->
      expect((1).seconds).toBe 1000
  describe "minutes", ->
    it 'should convert number to minutes', ->
      expect((1).minutes).toBe 1000*60
  describe "hours", ->
    it 'should convert number to hours', ->
      expect((1).hours).toBe 1000*60*60
  describe "days", ->
    it 'should convert number to days', ->
      expect((1).days).toBe 1000*60*60*24