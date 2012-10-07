describe "Function", ->
  describe "delay", ->
    it 'should run the function after x seconds', ->
      a = =>
        @x = true
      runs =>
        a.delay 100, @
      waitsFor ->
        !!@x
      , 'Not ran', 2100
      runs =>
        expect(@x).toBe true
  describe "periodical", ->
    it 'should run the function every x seconds', ->
      @x = 0
      a = =>
        @x++
      runs =>
        a.periodical 10, @
      waitsFor ->
        @x is 10
      , 'Not ran', 100
      runs =>
        expect(@x).toBe 10

