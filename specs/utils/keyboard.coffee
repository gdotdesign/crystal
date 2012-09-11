xdescribe 'i18n', ->
	class TestKeyboard extends Keyboard
		shortcuts: ->
			"ctrl+shift+esc": 'test'
		test: ->
			alert('test')

	keyboard = new TestKeyboard
	it 'should fire method when shortcut is called', ->
		spyOn(keyboard, 'test')
		evt = document.createEvent("KeyboardEvent")
		evt.initKeyboardEvent "keyup", true, true, window, 0, 27, 0, "Control Shift"
		console.log evt
		document.dispatchEvent(evt)
		expect(keyboard.test).toHaveBeenCalled()