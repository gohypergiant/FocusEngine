###
	# USING THE FOCUSENGINE
	
	# Require the module
	fe = require "FocusEngine"
	
	# Collect layers which will participate into an array
	myFocusableLayers = [layerA, layerB, layerC]
	
	# Initialize the engine with your array
	fe.initialize(myFocusableLayers)
	
	# Optionally attach changeFocus() to keyboard events
	document.addEventListener "keydown", (event) ->
		keyCode = event.which
		switch keyCode
			when 13 then fe.changeFocus("select")
			when 37 then fe.changeFocus("left")
			when 38 then fe.changeFocus("up")
			when 39 then fe.changeFocus("right")
			when 40 then fe.changeFocus("down")
			else null
	
	# Customize focus state
	fe.focusStyle.shadowColor = <string> (hex or rgba)
	fe.focusStyle.scale = <number>
	fe.focusStyle.shadowX = <number>
	fe.focusStyle.shadowY = <number>
	fe.focusStyle.shadowBlur = <number>
	
	# Place initial focus
	fe.placeFocus(layerA)
	
	# previousFocus() is available to use in conjunction with FlowComponent's showPrevious()
	fe.previousFocus()
	
	# Layers can trigger behavior upon receiving or losing focus, or being selected
	layerA.on "focus", ->
	layerA.on "unfocus", ->
	layerA.on "selected", ->
	
	# Integration with RemoteLayer (https://github.com/bpxl-labs/RemoteLayer)
	RemoteLayer = require "RemoteLayer"
	myRemote = new RemoteLayer
		clickAction: -> fe.changeFocus("select")
		swipeUpAction: -> fe.changeFocus("up")
		swipeDownAction: -> fe.changeFocus("down")
		swipeLeftAction: -> fe.changeFocus("left")
		swipeRightAction: -> fe.changeFocus("right")
		
	# Enable debug mode to log focus changes
	fe.debug = true
###

exports.debug = false

# focus store
exports.focus = null
exports.initialFocus = null
exports.previousFocus = null
exports.focusable = []

# focus style
exports.focusStyle =
	scale: 1.1
	shadowBlur: 20
	shadowColor: "rgba(0,0,0,0.3)"
	shadowX: 0
	shadowY: 0
	shadowSpread: 0

exports.unfocusStyle =
	shadowBlur: 20
	shadowColor: "rgba(0,0,0,0)"
	shadowX: 0
	shadowY: 0
	shadowSpread: 0

# prep focus states
exports.initialize = (focusableArray) ->
	exports.focusable = focusableArray
	for layer in exports.focusable 
		layer.states.focus =
			scale: layer.scale * exports.focusStyle.scale
			shadowBlur: exports.focusStyle.shadowBlur
			shadowSpread: exports.focusStyle.shadowSpread
			shadowColor: exports.focusStyle.shadowColor
			shadowX: exports.focusStyle.shadowX
			shadowY: exports.focusStyle.shadowY
		layer.states.unfocus =
			scale: layer.scale
			shadowBlur: exports.unfocusStyle.shadowBlur
			shadowSpread: exports.unfocusStyle.shadowSpread
			shadowColor: exports.unfocusStyle.shadowColor
			shadowX: exports.unfocusStyle.shadowX
			shadowY: exports.unfocusStyle.shadowY
		layer.animate("unfocus", instant: true)
		

# layer visibility
checkVisible = (layer) ->
	isVisible = true
	if layer.visible == false
		isVisible = false
		return isVisible
	for ancestor in layer.ancestors()
		if ancestor?.visible == false
			isVisible = false
			return isVisible
		else
			isVisible = true
	return isVisible
	
# focus change
exports.placeFocus = (layer = null) ->
	if layer == null
		return
	# store initial focus on first run
	if exports.initialFocus == null
		exports.initialFocus = layer
	# store current focus for returning easily
	if exports.focus != null
		exports.previousFocus = exports.focus
	if checkVisible(layer) == true and layer != null
		exports.focus = layer
		exports.unfocusAll()
		layer.emit "receivedFocus"
		if layer != null and layer in exports.focusable
			layer?.animate("focus")
	
exports.unfocusAll = () ->
	for layer in exports.focusable
		layer.emit "lostFocus"
		if layer.states.current.name == "focus"
			layer.animate("unfocus")
		
exports.focusPrevious = () ->
	if exports.previousFocus != null
		exports.placeFocus(exports.previousFocus)

exports.changeFocus = Utils.throttle 0.1, (direction) ->
	if exports.debug == true
		print "current: " + exports.focus?.name + "; direction: " + direction
	tempArray = []
	# if we've lost all focus, reset 
	if exports.focus == null or exports.focus == undefined
		exports.placeFocus(exports.initialFocus)
	focusMidX = exports.focus.screenFrame.x + exports.focus.screenFrame.width/2
	focusMidY = exports.focus.screenFrame.y + exports.focus.screenFrame.height/2
	if direction == "up"
		for layer in exports.focusable
			layerMidY = layer.screenFrame.y + layer.screenFrame.height/2
			if layerMidY < focusMidY
				tempArray.push(layer)
	else if direction == "down"
		for layer in exports.focusable
			layerMidY = layer.screenFrame.y + layer.screenFrame.height/2
			if layerMidY > focusMidY
				tempArray.push(layer)
	else if direction == "left"
		for layer in exports.focusable
			layerMidX = layer.screenFrame.x + layer.screenFrame.width/2
			if layerMidX < focusMidX
				tempArray.push(layer)
	else if direction == "right"
		for layer in exports.focusable
			layerMidX = layer.screenFrame.x + layer.screenFrame.width/2
			if layerMidX > focusMidX
				tempArray.push(layer)
	else if direction == "select"
		exports.focus.emit "selected"
	if tempArray.length == 0
		return
	targetLayer = tempArray[0]
	shortestDistance = measureDistance(targetLayer, direction)
	for layer in tempArray
		distance = measureDistance(layer, direction)
		if distance < shortestDistance
			targetLayer = layer
			shortestDistance = distance
	exports.placeFocus(targetLayer)

measureDistance = (target, direction) ->
	focusTopCenter = 
		x: exports.focus.screenFrame.x + exports.focus.screenFrame.width/2
		y: exports.focus.screenFrame.y
	focusBottomCenter = 
		x: exports.focus.screenFrame.x + exports.focus.screenFrame.width/2
		y: exports.focus.screenFrame.y + exports.focus.screenFrame.height
	focusLeftCenter = 
		x: exports.focus.screenFrame.x
		y: exports.focus.screenFrame.y + exports.focus.screenFrame.height/2
	focusRightCenter = 
		x: exports.focus.screenFrame.x + exports.focus.screenFrame.width
		y: exports.focus.screenFrame.y + exports.focus.screenFrame.height/2
	targetTopCenter = 
		x: target.screenFrame.x + target.screenFrame.width/2
		y: target.screenFrame.y
	targetBottomCenter = 
		x: target.screenFrame.x + target.screenFrame.width/2
		y: target.screenFrame.y + target.screenFrame.height
	targetLeftCenter = 
		x: target.screenFrame.x
		y: target.screenFrame.y + target.screenFrame.height/2
	targetRightCenter = 
		x: target.screenFrame.x + target.screenFrame.width
		y: target.screenFrame.y + target.screenFrame.height/2
	switch direction
		when "up"
			distanceX = focusTopCenter.x - targetBottomCenter.x
			distanceY = focusTopCenter.y - targetBottomCenter.y
		when "down"
			distanceX = focusBottomCenter.x - targetTopCenter.x
			distanceY = focusBottomCenter.y - targetBottomCenter.y
		when "left"
			distanceX = focusLeftCenter.x - targetRightCenter.x
			distanceY = focusLeftCenter.y - targetRightCenter.y
		when "right"
			distanceX = focusRightCenter.x - targetLeftCenter.x
			distanceY = focusRightCenter.y - targetLeftCenter.y
	# Pythagorean theorem to measure the hypoteneuse
	absoluteDistance = Math.sqrt(distanceX * distanceX + distanceY * distanceY)
	return absoluteDistance
	
