define ->
  # FIXME
  Browser = 
    ANDOID: 1
    IPHONE: 2
    IPAD: 3
    WEBOS: 4
    TOUCHPAD: 5
    BLACKBERRY: 6
    KINDLE: 7
    SILK: 8
    
  ua = navigator.userAgent

  android = ua.match(/(Android)\s+([\d.]+)/)
  webkit = ua.match(/WebKit\/([\d.]+)/)
  ipad = ua.match(/(iPad).*OS\s([\d_]+)/)
  iphone = not ipad and ua.match(/(iPhone\sOS)\s([\d_]+)/)
  webos = ua.match(/(webOS|hpwOS)[\s\/]([\d.]+)/)
  touchpad = webos and ua.match(/TouchPad/)
  kindle = ua.match(/Kindle\/([\d.]+)/)
  silk = ua.match(/Silk\/([\d._]+)/)
  blackberry = ua.match(/(BlackBerry).*Version\/([\d.]+)/)

  browser.version = webkit[1] if browser.webkit = !!webkit
  Browser.platform = Browser.ANDROID if android
  Browser.platform = Browser.IPHONE if iphone
  Browser.platform = Browser.IPAD if ipad
  Browser.platform = Browser.WEBOS if webos
  Browser.platform = Browser.TOUCHPAD if touchpad
  Browser.platform = Browser.BLACKBERRY if blackberry
  Browser.platform = Browser.KINDLE if kindle
  Browser.platform = Browser.SILK if silk
  
  Browser
