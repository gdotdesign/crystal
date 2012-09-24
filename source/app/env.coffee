window.Platforms = 
  WEBSTORE: 1
  NODE_WEBKIT: 2
  WEB:3
  
window.PLATFORM = if window.location.href.match(/^chrome-extension\:\/\//)
    WEBSTORE
  else if 'require' of window
    NODE_WEBKIT
  else
    WEB