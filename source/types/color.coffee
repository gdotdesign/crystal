# @requires ./number
window.Color = class Color
  constructor: (color = "FFFFFF") ->
    if (match = color.match /^#?([0-9a-f]{3}|[0-9a-f]{6})$/i)
      if color.match /^#/
        hex = color[1..]
      else
        hex = color
      if hex.length is 3
        hex = hex.replace(/([0-9a-f])/gi, '$1$1')
      @type = 'hex'
      @_hex = hex
      @_alpha = 100
      @_update 'hex'
    else if (match = color.match /^hsla?\((\d{0,3}),\s*(\d{1,3})%,\s*(\d{1,3})%(,\s*([01]?\.?\d*))?\)$/)?
      @type = 'hsl'
      @_hue = parseInt(match[1]).clamp 0, 360
      @_saturation = parseInt(match[2]).clamp 0, 100
      @_lightness = parseInt(match[3]).clamp 0, 100
      @_alpha = parseInt(parseFloat(match[5])*100) || 100
      @_alpha = @_alpha.clamp 0, 100
      @type += if match[5] then "a" else ""
      @_update 'hsl'
    else if (match = color.match /^rgba?\((\d{1,3}),\s*(\d{1,3}),\s*(\d{1,3})(,\s*([01]?\.?\d*))?\)$/)?
      @type = 'rgb'
      @_red = parseInt(match[1]).clamp 0, 255
      @_green = parseInt(match[2]).clamp 0, 255
      @_blue = parseInt(match[3]).clamp 0, 255
      @_alpha = parseInt(parseFloat(match[5])*100) || 100
      @_alpha = @_alpha.clamp 0, 100
      @type += if match[5] then "a" else ""
      @_update 'rgb'
    else
      throw 'Wrong color format!'

  invert: ->
    @_red = 255 - @_red
    @_green = 255 - @_green
    @_blue = 255 - @_blue
    @_update 'rgb'
    @

  ###
  TODO refactor
  mix: (color2, alpha) ->
    for item in [0,1,2]
      @rgb[item] = Utils.clamp(((@rgb[item] / 100 * (100 - alpha))+(color2.rgb[item] / 100 * alpha)), 0, 255)
    @_update 'rgb'
    @
  ###

  _hsl2rgb: ->
    h = @_hue / 360
    s = @_saturation / 100
    l = @_lightness / 100
    if s is 0
      val = l * 255
      return [ val, val, val ]
    if l < 0.5
      t2 = l * (1 + s)
    else
      t2 = l + s - l * s
    t1 = 2 * l - t2
    rgb = [ 0, 0, 0 ]
    i = 0

    while i < 3
      t3 = h + 1 / 3 * -(i - 1)
      t3 < 0 and t3++
      t3 > 1 and t3--
      if 6 * t3 < 1
        val = t1 + (t2 - t1) * 6 * t3
      else if 2 * t3 < 1
        val = t2
      else if 3 * t3 < 2
        val = t1 + (t2 - t1) * (2 / 3 - t3) * 6
      else
        val = t1
      rgb[i] = val * 255
      i++
    @_red = rgb[0]
    @_green = rgb[1]
    @_blue = rgb[2]

  _hex2rgb: ->
    value = parseInt(@_hex, 16)
    @_red = value >> 16
    @_green = (value >> 8) & 0xFF
    @_blue = value & 0xFF

  _rgb2hex: ->
    value = (@_red << 16 | (@_green << 8) & 0xffff | @_blue)
    x = value.toString(16)
    x = '000000'.substr(0, 6 - x.length) + x
    @_hex = x.toUpperCase()

  _rgb2hsl: ->
    r = @_red / 255
    g = @_green / 255
    b = @_blue / 255
    min = Math.min(r, g, b)
    max = Math.max(r, g, b)
    delta = max - min
    if max is min
      h = 0
    else if r is max
      h = (g - b) / delta
    else if g is max
      h = 2 + (b - r) / delta
    else h = 4 + (r - g) / delta  if b is max
    h = Math.min(h * 60, 360)
    h += 360  if h < 0
    l = (min + max) / 2
    if max is min
      s = 0
    else if l <= 0.5
      s = delta / (max + min)
    else
      s = delta / (2 - max - min)
    @_hue = h
    @_saturation = s * 100
    @_lightness = l *100

  _update: (type) ->
    switch type
      when 'rgb'
        @_rgb2hsl()
        @_rgb2hex()
      when 'hsl'
        @_hsl2rgb()
        @_rgb2hex()
      when 'hex'
        @_hex2rgb()
        @_rgb2hsl()

  toString: (type = 'hex')->
    switch type
      when "rgb"
        "rgb(#{@_red}, #{@_green}, #{@_blue})"
      when "rgba"
        "rgba(#{@_red}, #{@_green}, #{@_blue}, #{@alpha/100})"
      when "hsl"
        "hsl(#{@_hue}, #{Math.round(@_saturation)}%, #{Math.round(@_lightness)}%)"
      when "hsla"
        "hsla(#{@_hue}, #{Math.round(@_saturation)}%, #{Math.round(@_lightness)}%, #{@alpha/100})"
      when "hex"
        @hex

['red','green','blue'].forEach (item) ->
  Object.defineProperty Color::, item,
    get: ->
      @["_"+item]
    set: (value) ->
      @["_"+item] = parseInt(value).clamp 0, 255
      @_update 'rgb'

['lightness','saturation'].forEach (item) ->
  Object.defineProperty Color::, item,
    get: ->
      @["_"+item]
    set: (value) ->
      @["_"+item] = parseInt(value).clamp 0, 100
      @_update 'hsl'

['rgba','rgb','hsla','hsl'].forEach (item) ->
  Object.defineProperty Color::, item,
    get: ->
      @toString(item)

Object.defineProperties Color::,
  hex:
    get: ->
      @_hex
    set: (value) ->
      @_hex = value
      @_update 'hex'
  hue:
    get: ->
      @_hue
    set: (value) ->
      @_hue = parseInt(value).clamp 0, 360
      @_update 'hsl'
  alpha:
    get: ->
      @_alpha
    set: (value) ->
      @_alpha = parseInt(value).clamp 0, 100