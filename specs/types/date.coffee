define ['source/types/date'], ->
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
        expect(@d.format("%h")).toBe '5'
      it 'should format hours (with leading zero)', ->
        expect(@d.format("%H")).toBe '05'

      it 'should format mintues', ->
        expect(@d.format("%t")).toBe '9'
      it 'should format mintues (with leading zero)', ->
        expect(@d.format("%T")).toBe '09'