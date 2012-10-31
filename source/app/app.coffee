# @requries ../utils/evented

_wrap = (name, app)->
  (data,fn) ->
    if data instanceof Object
      for key, value of data
        app[name].call app, key, value
    else
      app[name].call app, data, fn

window.Application = class Application extends Utils.Evented
  constructor: (@root = document)->
    @logger = new ConsoleLogger
    @keyboard = new Keyboard
    @router = new History
    window.addEvent 'load', => @trigger 'load'
    ###
    nw > 3.0
    if PLATFORM is Platforms.NODE_WEBKIT
      win = require('nw.gui').Window.get()
      win.on 'close', ->
      win.on 'minimize', => @trigger 'minimize'
    ###

  set: (name,value) ->
    switch name
      when "logger"
        @logger = new value
      else
        @[name] = value

  get: (key, fn)->
    @router[key] = fn.bind @
  sc: (key, fn) ->
    @keyboard[key] = fn.bind @
  def: (key, fn) ->
    @[key] = fn

  event: (key,fn) ->
    @root.delegateEvent key, fn.bind @

  on: (name,fn)->
    if name is 'end'
      window.onbeforeunload = fn
    else
      super

  subscribe: (name, callback)->
    super name, callback.bind @

  @new: (func) ->
    (root) =>
      @app = new Application root
      context = {}
      for key of @app
        context[key] = _wrap(key,@app)
      func.call context
      @app.trigger 'load'
      @app