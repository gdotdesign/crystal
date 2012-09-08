# requires ./path
# requires ../types/object

# i18n support
#
# @example Getting locles from ajax
#   r = new Request('/locales')
#     r.get (response) ->
#       i18n.locales = response.json
#    i18n.t 'menu.home'
#
class i18n
  @locales: {}
  # Gets translation for given path
  # 
  # @example Default locale
  #   i18.n.t 'menu.home'
  #
  # @example Explicit locale
  #   i18.n.t 'menu.home', 'en'
  #
  # @example Data for replacement
  #   i18n.locale.en
  #     site:
  #       welcome: 'Welcome {{name}}!'
  #   i18.n.t 'site.welcome', {name: 'Joe'}
  #
  # @example Data and locale
  #   i18.n.t 'menu.home', data, 'en' 
  @t: (path) ->
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

window.i18n = i18n