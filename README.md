# FocusEngine Framer Module

[![license](https://img.shields.io/github/license/bpxl-labs/RemoteLayer.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](.github/CONTRIBUTING.md)
[![Maintenance](https://img.shields.io/maintenance/yes/2017.svg)]()

The FocusEngine module allows you to simulate the grid focus behavior seen on streaming media players like Apple TV and Roku. Use the keyboard, [RemoteLayer](https://github.com/bpxl-labs/RemoteLayer) or another mechanism to direct focus around the screen.

Once initialized, any _visible_ layer can be brought into focus, even if it’s off screen. This permits the activation of offscreen menus. Visual appearance of focused elements can be customized.

<img src="https://cloud.githubusercontent.com/assets/935/23135402/18b99578-f75e-11e6-9795-b619b40ddd4a.gif" width="497" style="display: block; margin: auto" alt="FocusEngine preview" />

### Installation

#### Manual Installation

Copy / save the `FocusEngine.coffee` file into your project's `modules` folder.

### Adding It To Your Project

In your Framer project add the following:

```javascript
fe = require "FocusEngine"
```

### API

#### Collect layers which will participate into an array
	
```coffeescript
myFocusableLayers = [layerA, layerB, layerC]
```

#### Initialize the engine with your array
```coffeescript
fe.initialize(myFocusableLayers)
```

#### Optionally attach changeFocus() to keyboard events
```coffeescript
document.addEventListener "keydown", (event) ->
	keyCode = event.which
	switch keyCode
		when 13 then fe.changeFocus("select")
		when 37 then fe.changeFocus("left")
		when 38 then fe.changeFocus("up")
		when 39 then fe.changeFocus("right")
		when 40 then fe.changeFocus("down")
		else null
```

#### Customize focus and unfocused states
```coffeescript
fe.focusStyle.scale = <number>
fe.focusStyle.shadowX = <number>
fe.focusStyle.shadowY = <number>
fe.focusStyle.shadowColor = <string> (hex or rgba)
fe.focusStyle.shadowBlur = <number>
fe.focusStyle.shadowSpread = <number>

fe.unfocusStyle.shadowX = <number>
fe.unfocusStyle.shadowY = <number>
fe.unfocusStyle.shadowColor = <string> (hex or rgba)
fe.unfocusStyle.shadowBlur = <number>
fe.unfocusStyle.shadowSpread = <number>
```

(Unfocused scale is always assumed to be the layer’s original scale.)

#### Place initial focus
```coffeescript
fe.placeFocus(layerA)
```

#### previousFocus() is available to use in conjunction with FlowComponent's showPrevious()
```coffeescript
fe.previousFocus()
```

#### Layers can trigger behavior upon receiving or losing focus, or being selected
```coffeescript
layerA.on "focus", ->
layerA.on "unfocus", ->
layerA.on "selected", ->
```

#### Integration with [RemoteLayer](https://github.com/bpxl-labs/RemoteLayer)
```coffeescript
RemoteLayer = require "RemoteLayer"
myRemote = new RemoteLayer
	clickAction: -> fe.changeFocus("select")
	swipeUpAction: -> fe.changeFocus("up")
	swipeDownAction: -> fe.changeFocus("down")
	swipeLeftAction: -> fe.changeFocus("left")
	swipeRightAction: -> fe.changeFocus("right")
```

#### Enable debug mode to log focus changes
```coffeescript
fe.debug = true
```

---

Website: [blackpixel.com](https://blackpixel.com) &nbsp;&middot;&nbsp;
GitHub: [@bpxl-labs](https://github.com/bpxl-labs/) &nbsp;&middot;&nbsp;
Twitter: [@blackpixel](https://twitter.com/blackpixel) &nbsp;&middot;&nbsp;
Medium: [@bpxl-craft](https://medium.com/bpxl-craft)
