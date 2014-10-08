console.log( 'Bootstraping Ethos...', process, global )
_ = require 'underscore'
querystring = require 'querystring'

process.on "uncaughtException", (err) -> 
	alert("error: " + err)

if global?
	try
		gui = require('nw.gui')
	catch err
		console.log( "Error: ", err )

	app = gui.App

	windows = []

	# Attach event bus / vent to global object using EventEmitter
	EventEmitter = require( 'events' )	
	global.vent = new EventEmitter()

	# Get the bootstrap window (this one) and hide it.
	win = gui.Window.get()
	win.showDevTools()
	win.hide()

	windows.push( win )

	# Create a new main window for app content.
	mainWindowOptions =
		show: true
		toolbar: true
		frame: true
		icon: "./app/images/ethos-logo.png"
		"inject-js-start": "./app/scripts/inject.bundle.js"
		position: "center"
		width: 1024
		height: 768
		min_width: 300
		min_height: 200
	
	mainWindow = gui.Window.open( 'http://eth:8080/', mainWindowOptions )
	mainwin = gui.Window.get( mainWindow )
	windows.push( mainwin )
	mb = new gui.Menu( type:"menubar" )

	if process.platform is 'darwin'
		mb.createMacBuiltin( "Ethos" )
	
	mainwin.menu = mb

	mainwin.onerror = -> alert('err')
	mainWindow.on 'document-end', ->
		console.log( 'Loaded new window in mainwin')
		console.log( window.location.href )

	dialogwin = dialogWindow = null

	global.showDialog = (data = {}) ->
		# Create a new dialog window for notifications
		defaultDialogWindowOptions =
			url: 'http://eth:8080/ethos/dialog'
			frame: false
			toolbar: false
			resizable: false
			width: 400
			height: 200
		dialogWindowOptions = _.defaults( data, defaultDialogWindowOptions )
		url = "#{dialogWindowOptions.url}?#{querystring.stringify( dialogWindowOptions.query )}"
		dialogWindow = gui.Window.open( url, dialogWindowOptions )
		dialogwin = gui.Window.get( dialogWindow )

	global.showGlobalDev = ->
		console.log "showGlobalDev requested"
		win.showDevTools()

	global.vent.on 'close:dialog', (data) ->
		console.log "'close:dialog' event fired. data:", data
		console.log "global dialog wins:", dialogWindow, dialogwin
		dialogWindow.hide()



console.log( 'Ethos Bootstrap end: ok.' )