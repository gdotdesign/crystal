# @requires ./file

window.NWDialogs = new class NWDialogs
  constructor: ->
    @input = Element.create 'input'
    @input.setAttribute 'type', 'file'
    @input.addEventListener 'change', =>
      if @input.files.length > 0
        file = new NWFile(@input.files[0].path)
        @callback file

  open: (callback = ->)->
    @input.removeAttribute 'nwsaveas'
    @input.click()
    @type = "open"
    @callback = callback

  save: (callback = ->) ->
    @input.setAttribute 'nwsaveas', 'true'
    @callback = callback
    @type = "save"
    @input.click()