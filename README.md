# FocusEngine Framer Module

[![license](https://img.shields.io/github/license/bpxl-labs/RemoteLayer.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](.github/CONTRIBUTING.md)
[![Maintenance](https://img.shields.io/maintenance/yes/2017.svg)]()

The FocusEngine module allows you to simulate the grid focus behavior seen on streaming media players like Apple TV and Roku. Use the keyboard, [RemoteLayer](https://github.com/bpxl-labs/RemoteLayer), or another mechanism to direct focus around your prototype’s canvas.

Once initialized, any _visible_ layer can be brought into focus, even if it’s off screen. This permits the activation of off-screen menus. Visual appearance of focused elements can be customized.

<img src="https://cloud.githubusercontent.com/assets/935/24167436/bfaae7e0-0e44-11e7-846f-a47702716a28.gif" width="497" style="display: block; margin: auto" alt="FocusEngine preview" />

### Installation

#### NPM Installation

```
$ cd /your/framer/project
$ npm i @blackpixel/framer-focusengine
```

#### Manual installation

Copy or save the `FocusEngine.coffee` file into your project's `modules` folder.

### Adding It to Your Project

In your Framer project add the following:

```javascript
fe = require "FocusEngine"
```

### API

#### Customize focused and unfocused states
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

(Unfocused scale is always assumed to be the layer’s original scale. This need not be 1. You may get better visual results by drawing your layer slightly larger than needed and setting its initial scale to something less than 1.)

#### Collect layers that will participate into an array
	
```coffeescript
myFocusableLayers = [layerA, layerB, layerC]
```

#### Initialize the engine with your array
```coffeescript
fe.initialize(myFocusableLayers)
```

#### Add a layer created post-initialization
```coffeescript
fe.addLayer(layerD)
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

#### Place initial focus
```coffeescript
fe.placeFocus(layerA)
```

#### focusPrevious() is available to use in conjunction with FlowComponent's showPrevious()
```coffeescript
fe.focusPrevious()
```

(Note that focus cannot be placed on a layer whose visibility, or whose ancestor’s visibility, is false. You may need to delay calling `focusPrevious()` until the FlowComponent’s transition is ended, perhaps by using `.onTransitionEnd`.)

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
