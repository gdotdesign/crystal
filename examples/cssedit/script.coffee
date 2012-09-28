CssProperties = ['mask','mask-image','mask-position','mask-size','mask-repeat','mask-attachment','mask-origin','mask-clip','mask-color','mask-break','background','background-image','background-position','background-size','background-repeat','background-attachment','background-origin','background-clip','background-color','background-break','border','border-break','border-collapse','border-color','border-image','border-width','border-style','border-radius','border-top-right-radius','border-bottom-right-radius','border-bottom-left-radius','border-top-left-radius','border-bottom','border-bottom-color','border-bottom-style','border-bottom-width','border-top','border-top-color','border-top-style','border-top-width','border-left','border-left-color','border-left-style','border-left-width','border-right','border-right-color','border-right-style','border-right-width','font-style','font-variant','font-weight','font-size','font-size-adjust','font-stretch','font-family','clear','display','float','height','max-height','min-height','width','max-width','min-width','margin','margin-top','margin-right','margin-bottom','margin-left','padding','padding-top','padding-right','padding-bottom','padding-left','marquee-direction','marquee-loop','marquee-play-count','marquee-speed','marquee-style','overflow','overflow-style','overflow-x','overflow-y','rotation','rotation-point','visibility','direction','hanging-punctuation','letter-spacing','punctuation-trim','text-align','text-align-last','text-decoration','text-emphasis','text-indent','text-justify','text-outline','text-shadow','text-transform','text-wrap','unicode-bidi','white-space','white-space-collapse','word-break','word-spacing','word-wrap','color','opacity','border-collapse','border-spacing','caption-side','empty-cells','table-layout','list-style','list-style-type','list-style-position','list-style-image','marker-offset','outline','outline-color','outline-style','outline-width','outline-offset','bottom','clip','left','position','right','top','z-index','appearance','cursor','icon','nav-index','nav-up','nav-right','nav-down','nav-left','resize','column-count','column-fill','column-gap','column-rule','column-rule-width','column-rule-style','column-rule-color','columns','column-span','column-width','box-align','box-direction','box-flex','box-flex-group','box-lines','box-ordinal-group','box-orient','box-pack','box-sizing','tab-side','cue','cue-before','cue-after','mark','mark-before','mark-after','pause','pause-before','pause-after','phonemes','rest','rest-before','rest-after','speak','voice-balance','voice-duration','voice-family','voice-rate','voice-pitch','voice-pitch-range','voice-stress','voice-volume','animation','animation-name','animation-duration','animation-timing-function','animation-delay','animation-iteration-count','animation-direction','animation-play-state','transition','transition-property','transition-duration','transition-timing-function','transition-delay','grid-columns','grid-rows','backface-visibility','perspective','perspective-origin','transform','transform-origin','transform-style','bookmark-label','bookmark-target','border-length','content','counter-increment','counter-reset','crop','float-offset','hyphenate-after','hyphenate-before','hyphenate-character','hyphenate-lines','hyphenate-resource','hyphens','image-resolution','marks','move-to','page-policy','quotes','string-set','text-replace','alignment-adjust','alignment-baseline','baseline-shift','dominant-baseline','drop-initial-after-align','drop-initial-after-adjust','drop-initial-before-align','drop-initial-before-adjust','drop-initial-value','drop-initial-size','inline-box-align','line-height','line-stacking','line-stacking-strategy','line-stacking-ruby','line-stacking-shift','text-height','vertical-align','target','target-name','target-new','target-position','ruby-align','ruby-overhang','ruby-position','ruby-span','fit','fit-position','image-orientation','orphans','page','page-break-after','page-break-before','page-break-inside','size','windows']
class CSSProperty
  constructor: ->
    @base = Element.create '.prop'
    @_name = Element.create 'input[list=cssproperties]'
    @_value = Element.create 'input[list=background-position]'
    @_name.addEvent 'input', @update.bind @

    @base.append @_name, @_value
  update: ->
    unless @valid
      @base.classList.add 'invalid'
    else
      @base.classList.remove 'invalid'
  toString: ->
    @_name.value+":"+@_value.value+";"

Object.defineProperties CSSProperty::,
  valid:
    get: ->
      !!document.first("#"+@_name.getAttribute('list')).first("[value='#{@_name.value}']")
  value:
    get: ->
      @_value.value

class CSSRule
  constructor: ->
    @base = Element.create '.rule'
    @_name = Element.create 'input'
    @base.append @_name
    for i in [0..3]
      @base.append new CSSProperty().base


window.onload = ->
  for p in CssProperties
    document.first("#cssproperties").append Element.create("option[value=#{p}]")
  window.prop = new CSSRule()
  prop.base.append new CSSRule().base
  document.body.append prop.base