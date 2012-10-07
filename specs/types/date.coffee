describe "Date", ->
  beforeEach ->
    @d = new Date('Fri Apr 06 2012 05:09:00 GMT+0000 (CEST)')
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

  describe 'ago', ->
    xit "", ->

  describe 'month', ->
    it "should return month", ->
      expect(@d.month).toBe 4
  describe 'year', ->
    it "should return year", ->
      expect(@d.year).toBe 2012
  describe 'hours', ->
    xit "should return hours", ->
      expect(@d.hours).toBe 5
  describe 'minutes', ->
    it "should return minutes", ->
      expect(@d.minutes).toBe 9
  describe 'seconds', ->
    it "should return seconds", ->
      expect(@d.seconds).toBe 0
  describe 'day', ->
    it "should return day", ->
      expect(@d.day).toBe 6