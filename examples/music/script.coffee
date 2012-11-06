window.wrapper = new AudioWrapper

album = 'Jazz U'
artist = 'Antony Raijekov'
songs = ['Deep blue (2005)', 'Moment of Green (2005)', 'Go \'n\' Drop (2003)', 'Drop of whisper (2005)', 'Ambient-M (2003)', 'Don-ki-Not (2003)', 'EXIT 65 (2005)', 'Chillout me (2004)', 'Lightout (2003)', 'Fidder (2004)', 'While We Walk (2004)', 'By the Coast (2004)'];
src = ['01 - Deep blue (2005)', '02 - Moment of Green (2005)', '03 - Go \'n\' Drop (2003)', '04 - Drop of whisper (2005)', '05 - Ambient-M (2003)', '06 - Don-ki-Not (2003)', '07 - EXIT 65 (2005)', '08 - Chillout me (2004)', '09 - Lightout (2003)', '10 - Fidder (2004)', '11 - While We Walk (2004)', '12 - By the Coast (2004)'];
for song,i in songs
  wrapper.add new Song
    title: song
    album: album
    artist: artist
    src: 'http://dl.dropbox.com/u/157845/moosic/' + encodeURI(src[i]) + ".mp3"

Application.new ->
  @event
    'click:.icon-pause': -> wrapper.pause()
    'click:.icon-play': -> wrapper.play()
    'click:.icon-forward': -> wrapper.next()
    'click:.icon-backward': -> wrapper.prev()
    'click:.icon-repeat': (e) ->
      wrapper.repeat = !wrapper.repeat
      e.target.classList.toggle 'on'
    'click:.icon-random': (e) ->
      wrapper.shuffle = !wrapper.shuffle
      e.target.classList.toggle 'on'
    'click:.progress': (e) ->
      wrapper.audio.currentTime = e.layerX/parseInt(e.target.css 'width')*wrapper.audio.duration
    'click:.volume': (e) ->
      wrapper.audio.volume = e.layerX/parseInt(e.target.css 'width')
      e.target.setAttribute 'value', e.layerX/parseInt(e.target.css 'width')*100

  @on 'load', ->
    class ListItemView extends ModelView
      bindings:
        '.|text': 'title'
        '.|toggleClass': ['playing','playing']
      events:
        'click:li': (e)->
          @model.trigger 'play'
      constructor: ->
        super
        @model.on 'change', @render.bind @

    wrapper.on 'update', (e,fraction,time,duration) ->
      document.first('.current').text = (Math.round(time/60*100)/100).toString().replace '.', ':'
      document.first('.full').text = (Math.round(duration/60*100)/100).toString().replace '.', ':'
      document.first('progress').setAttribute 'value', fraction*100

    wrapper.on 'play', (e,song,index) =>
      document.first('.title').text = song.title
      document.first('.album').text = song.album
      document.first('.artist').text = song.artist
      document.first('.music-player').classList.remove 'idle'
      document.first('.icon-play').classList.add 'hide'
      document.first('.icon-pause').classList.remove 'hide'
    
    wrapper.on 'idle', =>
      document.first('.music-player').classList.add 'idle'
      document.first('.icon-play').classList.remove 'hide'
      document.first('.icon-pause').classList.add 'hide'
     
    wrapper.on 'pause', =>
      document.first('.music-player').classList.add 'idle'
      document.first('.icon-play').classList.remove 'hide'
      document.first('.icon-pause').classList.add 'hide'
    
    wrapper.on 'resume', =>
      document.first('.music-player').classList.remove 'idle'
      document.first('.icon-play').classList.add 'hide'
      document.first('.icon-pause').classList.remove 'hide'

    @list = new UI.List
      collection: wrapper.playlist
      element: 'li'
      prepare: (el,item) ->
        view = new ListItemView(item,el)
        view.render()
    document.first(".playlist").append @list.base
