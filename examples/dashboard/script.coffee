google.load("feeds", "1")

WebKitPoint::diff = (p) ->
  new WebKitPoint @x-p.x, @y-p.y

class Dragger extends Crystal.Utils.Evented
  constructor: ->
    @dummy = Element.create '.dummy'

    document.addEvent 'mousedown', (e) =>
      if e.target.webkitMatchesSelector('.title')
        @el = e.target.parent

        rect = @el.getBoundingClientRect()
        @dummy.css 'width', rect.width+"px"
        @dummy.css 'height', rect.height+"px"

        @offset = new WebKitPoint(e.pageX,e.pageY).diff new WebKitPoint(rect.left,rect.top)
        @el.parent.insertBefore @dummy, @el
        document.body.append @el
        @el.css '-webkit-transition-duration', '0'
        @el.css 'width', rect.width+"px"
        @el.css 'position', 'absolute'
        @el.css 'top', rect.top+"px"
        @el.css 'left', rect.left+"px"
        @el.css 'pointer-events', 'none'
        document.addEvent 'mousemove', @move
        document.addEvent 'mouseup', @up
  move: (e) =>
    box = if e.target.webkitMatchesSelector('.box') then e.target else e.target.ancestor(".box")
    li = if e.target.webkitMatchesSelector('li') then e.target else e.target.ancestor("li")
    if li and li.parent is document.first(".tabs")
      document.body.all(".tab")[li.parent.indexOf(li)].first('.column').append @dummy
    else if box
      box.parent.insertBefore @dummy, box
    else
      dummyColumn = @dummy.ancestor(".column")
      column = if e.target.webkitMatchesSelector('.column') then e.target else  e.target.ancestor(".column")
      if column and column isnt dummyColumn
        column.append @dummy
    @el.css 'top', (e.pageY-@offset.y)+"px"
    @el.css 'left', (e.pageX-@offset.x)+"px"

  up: =>
    if @el
      document.removeEvent 'mousemove', @move
      document.addEvent 'mouseup', @up

      rect = @dummy.getBoundingClientRect()
      @el.css '-webkit-transition-duration', '120ms'
      @el.css 'top', rect.top+"px"
      @el.css 'left', rect.left+"px"
      setTimeout =>
        @el.css 'pointer-events', 'auto'
        @el.css 'position','static'
        @el.css 'width', "auto"
        @dummy.parent.insertBefore @el, @dummy
        @dummy.dispose()
        @publish 'reorder'
        @el = null
      , 150

class Box extends Model
  properties:
    title: {}
  constructor: ->
    super
    Object.defineProperties @,
      base:
        value: Element.create '.box'
      content:
        value: Element.create '.content'
      titlebox:
        value: Element.create '.title'
      titleEl:
        value: Element.create 'span'
    @base.model = @
    @titlebox.append Element.create 'i.icon-remove'
    @base.delegateEvent 'click:.icon-remove', =>
      @base.dispose()
      @publish 'reorder'

    @base.append @titlebox, @content
    @titlebox.append @titleEl
    @titleEl.text = @title if @title
    @on 'change:title', => @titleEl.text = @title


class RSSEntry extends Model
  properties:
    title: {}
    link: {}

class RSSBox extends Box
  properties:
    title: {}
    url: {}
  constructor: ->
    super
    list = new UI.List
      base: 'ul'
      element: 'li'
      prepare: (li,item) ->
        a = Element.create "a[href=#{item.link}]"
        a.textContent = item.title
        a.setAttribute 'title', item.title
        a.setAttribute 'target', '_blank'
        li.append a
    Object.defineProperties @,
      list:
        value: list
    @content.append @list.base
    @load @url if @url

  load: (url) ->
    feed = new google.feeds.Feed(url)
    feed.setNumEntries(10)
    feed.load (result) =>
      c = new Collection()
      @title = result.feed.title
      for item in result.feed.entries
        c.push new RSSEntry {title: item.title, link: item.link}
      @list.bind c

class window.Column extends Crystal.Utils.Evented
  constructor: (@id) ->
    @base = Element.create '.column'
    @subscribe 'reorder', @update
    @load()

  update: =>
    @boxes = for child in @base.children
      child.model
    @save()

  save: ->
    localStorage.setItem @id, JSON.stringify(@boxes)
  load: ->
    boxes = JSON.parse localStorage.getItem @id
    if boxes
      for box in boxes
        @base.append new RSSBox(box).base


window.Tabs = []
addTab = (name) ->
  id = Tabs.length
  tab = Element.create '.tab'
  (1).upto 4, (j) ->
    c = new Column "tab#{id}:#{j}"
    tab.append c.base
  document.first('.warpper').append tab
  li = Element.create('li')
  li.text = name
  document.first(".tabs").append li
  Tabs.push name

window.onload = ->

  d = new Dragger()
  d.subscribe 'reorder', ->
    localStorage.setItem 'tabs', JSON.stringify Tabs

  document.delegateEvent 'dblclick:.tabs li', (e) -> 
    if name = prompt("Tab Name",e.target.text)
      e.target.text = name
      Tabs[e.target.parent.indexOf(e.target)] = name
      localStorage.setItem 'tabs', JSON.stringify Tabs

  document.delegateEvent 'click:.tabs li', (e) -> 
    tabs = document.body.all('.tab')
    for tab in tabs
      tab.classList.remove 'active'
    tabs[e.target.parent.indexOf(e.target)].classList.add 'active'

  document.first("button[name=tab]").addEvent 'click', ->
    addTab('Empty Tab')

  document.first("button[name=rss]").addEvent 'click', ->
    if url = prompt()
      document.first('.active .column').append new RSSBox({url:url}).base
      d.publish 'reorder'

  tabs = JSON.parse localStorage.getItem 'tabs'
  if tabs
    for tab in tabs
      addTab tab
  else
    addTab 'First Tab'
    localStorage.setItem 'tabs', JSON.stringify Tabs
  document.first(".tab").classList.add 'active'

