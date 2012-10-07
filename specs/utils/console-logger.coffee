describe 'ConsoleLogger', ->
  oldconsole = window.console
  beforeEach ->
    window.console = {}
    ['log','error','info', 'warn'].forEach (type)->
      window.console[type] = ->
    ['log','error','info', 'warn'].forEach (type)->
      spyOn(console, type)
  afterEach ->
    window.console = oldconsole

  ['debug','error', 'fatal', 'info', 'warn','log'].forEach (type)->
    describe type, ->
      it "should add #{type} class", ->
        logger = new ConsoleLogger()
        logger[type] 'Hello'
        type = 'log' if type is 'debug'
        type = 'error' if type is 'fatal'
        expect(console[type]).toHaveBeenCalled()