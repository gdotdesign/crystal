define ['./path','../types/object'], (Path) ->
  window.i18n =
    locales: {}
    t: (path) ->
      if arguments.length is 2
        if (arg = arguments[1]) instanceof Object
          params = arg
        else
          locale = arg
      if arguments.length is 3
        locale = arguments[2]
        params = arguments[1]
      locale ?= document.querySelector('html').getAttribute('lang') or 'en'
      _path = new Path @locales[locale]
      str = _path.lookup path
      unless str
        console.warn "No translation found for '#{path}' for locale '#{locale}'"
        return path
      str.replace /\{\{(.*?)\}\}/g, (m,prop) ->
        if params[prop] isnt undefined then params[prop].toString() else ''
