document.delegateEvent 'change:input', (e) ->
	document.body.append Element.create(e.target.value)
	e.target.value = ''

document.addEvent 'DOMNodeInserted', (e) ->
	console.log e.target.toString()