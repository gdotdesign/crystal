# Song Model
class Song extends Model
  properties: 
    title: {}
    cover: {}
    src: {}
    album: {}
    artist: {}
    playing: {}
  constructor: ->
    super
    @playing = false

# Wappre for audio element
class AudioWrapper extends Model
  properties:
    currentTime: {}
    duration: {}
    shuffle: {}
    repeat: {}
    playing: {}
    progress: {}
    idle: {}
    volume: (value) ->
      @audio.volume = parseFloat(value).clamp 0, 1
      value*100

  constructor: (options)-> 
    super
    {@repeat,@shuffle} = options || {repeat: false, shuffle: false}

    if (tag = document.createElement('audio')).canPlayType
      if tag.canPlayType('audio/mpeg')
        @audio = tag
        @audio.preload = 'preload'
        @audio.autobuffer = true
        @audio.volume = 0
        @addEvents()
        @playing = null
        @idle = true
        @currentTime = "0:00"
        @duration = "0:00"
        @playlist = new Collection
        @playlist.on 'change', (e,mutation) =>
          for song in mutation.added
            song[0].on 'play', => @play song[0], true
          # TODO GC on remove
    
  seek: (value) ->
    @audio.currentTime = value*@audio.duration

  addEvents: ->
    @audio.addEventListener "timeupdate", @update
    @audio.addEventListener "ended", @next

  _formatToTime: (ms)->
    (Math.round(ms/60*100)/100).toString().replace '.', ':'
  
  update: =>
    @progress = (@audio.currentTime / @audio.duration)*100
    @currentTime = @_formatToTime @audio.currentTime
    @duration = @_formatToTime @audio.duration
    
  stop: ->
    if @playing?
      @audio.pause()
      @audio.src = null
      @playing.playing = false
      @playing = null
      @idle = true
  
  pause: ->
    if @playing?
      @audio.pause()
      @playing.playing = false
      @idle = true
  
  next: =>
    if @shuffle
      @play @playlist.sample
    else if (a = @playlist[@playlist.indexOf(@playing)+1])?
      @play a, true
    else if @repeat
      @play @playlist[0]
    else
      @stop()
 
  prev: ->
    if @shuffle
      @play @playlist.sample
    else if (a = @playlist[@playlist.indexOf(@playing)-1])?
      @play(a,true)
    else if @repeat
      @play @playlist.last
    else
      @stop()
        
  play: (song,force = false) ->
    if @playing? and not force
      if @audio.paused
        @audio.play()
        @playing.playing = true
        @idle = false
        return null
    if song?
      if typeof song is 'number'
        song = @playlist[song-1]
      if song?
        if @playlist.indexOf(song) is -1
          @add song
    else
      song = @playlist[0]
    if song?
      if @playing? 
        @playing.playing = false
      @playing = song
      @playing.playing = true
      @audio.src = @playing.src
      @audio.play()
      @idle = false

# Custom Bindings
Bindings.define 'song', (el,property) ->
  if @playing
    el.text = @playing[property]

# Views
class ListItemView extends ModelView
  bindings:
    '.|text': 'title'
    '.|toggleClass': ['playing','playing']
  events:
    'click:li': (e) -> @model.trigger 'play'
  constructor: ->
    super
    @model.on 'change', @render.bind @

class MusicPlayerView extends ModelView
  bindings:
    '.progress|value': 'progress'
    '.volume|value': 'volume'
    '.current|text': 'currentTime'
    '.full|text': 'duration'
    '.title|song': 'title'
    '.artist|song': 'artist'
    '.album|song': 'album'
    '.|toggleClass': ['idle','idle']
    '.icon-play|toggleClass': ['idle','hide',true]
    '.icon-pause|toggleClass': ['idle','hide']
    '.icon-repeat|toggleClass': ['repeat','on']
    '.icon-random|toggleClass': ['shuffle','on']
  events:
    'click:.progress':        (e) -> @model.seek e.layerX/parseInt(e.target.css 'width')
    'click:.volume':          (e) -> @model.volume = e.layerX/parseInt(e.target.css 'width')
    'click:.icon-pause':          -> @model.pause()
    'click:.icon-play':           -> @model.play()
    'click:.icon-forward':        -> @model.next()
    'click:.icon-backward':       -> @model.prev()
    'click:.icon-repeat':     (e) -> @model.repeat = !@model.repeat
    'click:.icon-random':     (e) -> @model.shuffle = !@model.shuffle
  constructor: ->
    super
    @model.on 'change', @render.bind @

# App
Application.new ->
  @on 'load', ->

    @wrapper = new AudioWrapper
    
    # Populate songs
    album = 'Jazz U'
    artist = 'Antony Raijekov'
    songs = ['Deep blue (2005)', 'Moment of Green (2005)', 'Go \'n\' Drop (2003)', 'Drop of whisper (2005)', 'Ambient-M (2003)', 'Don-ki-Not (2003)', 'EXIT 65 (2005)', 'Chillout me (2004)', 'Lightout (2003)', 'Fidder (2004)', 'While We Walk (2004)', 'By the Coast (2004)'];
    src = ['01 - Deep blue (2005)', '02 - Moment of Green (2005)', '03 - Go \'n\' Drop (2003)', '04 - Drop of whisper (2005)', '05 - Ambient-M (2003)', '06 - Don-ki-Not (2003)', '07 - EXIT 65 (2005)', '08 - Chillout me (2004)', '09 - Lightout (2003)', '10 - Fidder (2004)', '11 - While We Walk (2004)', '12 - By the Coast (2004)'];
    for song, i in songs
      s = new Song
        title: song
        album: album
        artist: artist
        src: 'http://dl.dropbox.com/u/157845/moosic/' + encodeURI(src[i]) + ".mp3"
      @wrapper.playlist.push s

    @list = new UI.List
      collection: @wrapper.playlist
      element: 'li'
      prepare: (el,item) ->
        new ListItemView(item,el).render()

    new MusicPlayerView @wrapper, document.first(".music-player")

    document.first(".playlist").append @list.base