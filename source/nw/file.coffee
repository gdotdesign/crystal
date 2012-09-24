window.NWFile = class NWFile
  constructor: (@path) ->
    @fs = window.fs or require 'fs'
  read: ->
    @fs.readFileSync @path, 'UTF-8'
  write: (data)->
    @fs.writeFileSync @path, data.toString(), 'UTF-8'