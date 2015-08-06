module.exports = (gui) ->
	process.on 'uncaughtException', (msg)->
		console.error "Error: Uncaught exexption: #{ msg }"

	os = process.platform
	ext = ''
	ext = '.exe' if os is 'win32'
	win = gui.Window.get()
	mb = new gui.Menu( type:"menubar" )
	mb.createMacBuiltin("Ethos") if os is 'darwin'
	gui.Window.get().menu = mb
		
	win.showDevTools()
	
	path = require 'path'
	web3 = require 'web3'
	spawn = require( 'child_process' ).spawn
	EthosMenu = require './EthosMenu.coffee'
	EthProcess = require './EthProcess.coffee'
	IPFSProcess = require './IPFSProcess.coffee'
	Config = require './Config.coffee'

	console.log( "Ξthos initializing..." )

	win.window.onload = ->		
		win.window.eth = ethProcess = new EthProcess({os, ext})
		win.window.ipfs = ipfsProcess = new IPFSProcess({os, ext})
		win.window.ethos = menu = new EthosMenu({gui,ipfsProcess, ethProcess})

		ethProcess.start()
		ipfsProcess.start()
		config = new Config()
		config.load()

		global.ethos =
			toggleLogging: ->
				ethProcess.logging = !ethProcess.logging
				ipfsProcess.logging = !ipfsProcess.logging
			config: config

		console.log( "Ξthos initialized: ok" )