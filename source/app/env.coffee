window.Platforms = 
  WEBSTORE: 1
  NODE_WEBKIT: 2
  WEB:3
  
window.PLATFORM = if window.location.href.match(/^chrome-extension\:\/\//)
    Platforms.WEBSTORE
  else if 'require' of window
    Platforms.NODE_WEBKIT
  else
    Platforms.WEB