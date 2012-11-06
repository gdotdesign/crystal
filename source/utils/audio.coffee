# @requires ./evented
# @requires ../mvc/collection
# @requires ../mvc/model


window.Song = class Song extends Model
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

window.AudioWrapper = class AudioWrapper extends Crystal.Utils.Evented
  constructor: (options)-> 
    {@repeat,@shuffle} = options || {repeat: false, shuffle: false}

    if (tag = document.createElement('audio')).canPlayType
      if tag.canPlayType('audio/mpeg')
        @audio = tag
        @audio.preload = 'preload'
        @audio.autobuffer = true
        @audio.volume = 0
        @addEvents()
        @playing = null
        @playlist = new Collection
        @playlist.on 'change', (e,mutation) =>
          for song in mutation.added
            song[0].on 'play', => @play song[0], true
    
  addEvents: ->
    @audio.addEventListener "timeupdate", @update
    @audio.addEventListener "ended", @next
  
  update: =>
    fraction = (time = @audio.currentTime) / (duration = @audio.duration)
    @trigger 'update', fraction, time, duration
    
  check: (obj) ->
    obj instanceof Song
  
  stop: ->
    if @playing?
      @audio.pause()
      @audio.src = null
      @playing.playing = false
      @playing = null
      @trigger 'idle'
  
  pause: ->
    if @playing?
      @audio.pause()
      @playing.playing = false
      @trigger 'pause'
  
  next: =>
    if @playing?
      if @shuffle
        @play @playlist.sample
      else if (a = @playlist[@playlist.indexOf(@playing)+1])?
        @play a, true
      else if @repeat
        @play @playlist[0]
      else
        @stop()
   
  prev: ->
    if @playing?
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
        @trigger 'resume', song
        return null
    if song?
      if typeof song is 'number'
        song = @playlist[song-1]
      if song?
        if @check song
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
      @trigger 'play', song

  empty: (obj) ->
    @stop()
    @playlist = new Collection()
  
  add: (obj) ->
    if @check obj
      @playlist.push obj
  
  remove: (obj) ->
    if @check(obj) and (index = @playlist.indexOf(obj)) isnt -1
      @playlist.remove$ obj