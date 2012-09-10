# @requires ./file

if require
  window.NW ?= {}
  window.NW.Dialogs = new class Dialogs
    constructor: ->
      @input = Element.create 'input'
      @input.setAttribute 'type', 'file'
      @input.addEventListener 'change', =>
        switch @type
          when 'open'
            if @input.files.length > 0
              file = new NW.File(@input.files[0].path)
              @callback file
          when 'save'
            if @input.files.length > 0
              file = new NW.File(@input.files[0].path)
              file.write @data
              @callback()

    open: (callback = ->)->
      @input.removeAttribute 'nwsaveas'
      @input.click()
      @type = "open"
      @callback = callback

    save: (data, callback = ->) ->
      @input.setAttribute 'nwsaveas', 'true'
      @data = data
      @callback = callback
      @type = "save"
      @input.click()