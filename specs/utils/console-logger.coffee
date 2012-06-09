define ['source/logger/console-logger'], (ConsoleLogger)->
  describe 'ConsoleLogger', ->
    window.console = {}
    ['log','error','info', 'warn'].forEach (type)->
      window.console[type] = ->
    beforeEach ->
      ['log','error','info', 'warn'].forEach (type)->
        spyOn(console, type)

    ['debug','error', 'fatal', 'info', 'warn',].forEach (type)->
      describe type, ->
        it "should add #{type} class", ->
          logger = new ConsoleLogger()
          logger[type] 'Hello'
          type = 'log' if type is 'debug'
          type = 'error' if type is 'fatal'
          expect(console[type]).toHaveBeenCalled()