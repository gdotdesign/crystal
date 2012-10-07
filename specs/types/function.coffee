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
        @asd = a.periodical 10, @
      waitsFor ->
        if @x is 10
          clearTimeout @asd
          true
        else
          false
      , 'Not ran', 200
      runs =>
        expect(@x).toBe 10

