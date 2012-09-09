describe "Date", ->
  beforeEach ->
    @d = new Date('Fri Apr 06 2012 05:09:00 GMT+0200 (CEST)')
  describe 'format', ->
    it 'should format days', ->
      expect(@d.format("%d")).toBe '6'
    it 'should format days (with leading zero)', ->
      expect(@d.format("%D")).toBe '06'

    it 'should format years', ->
      expect(@d.format("%Y")).toBe '2012'

    it 'should format months', ->
      expect(@d.format("%m")).toBe '4'
    it 'should format months (with leading zero)', ->
      expect(@d.format("%M")).toBe '04'

    it 'should format hours', ->
      hours = @d.getHours().toString()
      expect(@d.format("%h")).toBe hours
    it 'should format hours (with leading zero)', ->
      hours = @d.getHours()
      h = if hours < 10 then "0"+hours else ""+hours
      expect(@d.format("%H")).toBe h

    it 'should format mintues', ->
      expect(@d.format("%t")).toBe '9'
    it 'should format mintues (with leading zero)', ->
      expect(@d.format("%T")).toBe '09'

  describe 'month', ->
    it "should return month", ->
      expect(@d.month).toBe 4