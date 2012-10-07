describe 'i18n', ->

  key = Object.getOwnPropertyDescriptor(KeyboardEvent::,'key').get
  
  fireEvent = (keycode, ctrl, shift, alt) ->
    evt = document.createEvent("Event")
    evt.initEvent('keydown')
    evt.keyCode = keycode
    evt.key = key.call evt
    evt.ctrlKey = true if ctrl
    evt.shiftKey = true if shift
    evt.altKey = true if alt
    document.dispatchEvent(evt)

  class TestKeyboard extends Keyboard
    "ctrl+shift+esc": ->

  keyboard = new TestKeyboard
  it 'should fire method when shortcut is called', ->
    spyOn(keyboard, "ctrl+shift+esc")
    fireEvent 27, true, true, false
    expect(keyboard["ctrl+shift+esc"]).toHaveBeenCalled()