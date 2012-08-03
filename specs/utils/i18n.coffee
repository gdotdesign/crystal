define ['source/utils/i18n'], ->

  oldconsole = window.console
  beforeEach ->
    window.console = {}
    ['log','error','info', 'warn'].forEach (type)->
      window.console[type] = ->
    ['log','error','info', 'warn'].forEach (type)->
      spyOn(console, type)
  afterEach ->
    window.console = oldconsole

  describe 'i18n', ->
    it 'should return path for missing translation', ->
      expect(i18n.t('site.welcome')).toBe 'site.welcome'
    it 'should call console.warn in case of missing translation', ->
      i18n.t('site.welcome')
      expect(console.warn).toHaveBeenCalled()

    it 'should use html tag lang attribute as default', ->
      document.querySelector('html').setAttribute('lang','hu')
      i18n.locales.hu = {submit: 'Elküld'}
      expect(i18n.t('submit')).toBe 'Elküld'
      document.querySelector('html').removeAttribute('lang')

    it 'should use hen as default locale if not specified', ->
      expect(document.querySelector('html').getAttribute('lang')).toBe null
      i18n.locales.en = {submit: 'Submit'}
      expect(i18n.t('submit')).toBe 'Submit'

    it 'should return translation', ->
      i18n.locales.en = {submit: 'Submit'}
      expect(i18n.t('submit')).toBe 'Submit'
    it 'should return translation deep', ->
      i18n.locales.en.social =
        facebook:
          title: 'Facebook'
      expect(i18n.t('social.facebook.title')).toBe 'Facebook'

    it 'should return translation for different locale', ->
      i18n.locales.hu = {submit: 'Elküld'}
      expect(i18n.t('submit','hu')).toBe 'Elküld'
    it 'should return translation for different locale deep', ->
      i18n.locales.hu.social =
        facebook:
          title: 'Facebook'
      expect(i18n.t('social.facebook.title','hu')).toBe 'Facebook'

    it 'should substitue properties', ->
      i18n.locales.en.welcome = 'Welcome {{name}}!'
      expect(i18n.t('welcome',{name: 'joe'})).toBe 'Welcome joe!'
    it 'should substitue properties for different locale', ->
      i18n.locales.hu.welcome = 'Üdv {{name}}!'
      expect(i18n.t('welcome',{name: 'joe'},'hu')).toBe 'Üdv joe!'