# FocusEngine Framer Module

[![license](https://img.shields.io/github/license/bpxl-labs/RemoteLayer.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](.github/CONTRIBUTING.md)
[![Maintenance](https://img.shields.io/maintenance/yes/2017.svg)]()

<a href="https://open.framermodules.com/focusengine"><img alt="Install with Framer Modules" src="https://www.framermodules.com/assets/badge@2x.png" width='160' height='40' /></a>

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

```coffeescript
# If you manually installed
fe = require "FocusEngine"
# else
fe = require "@blackpixel/framer-focusengine"
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

#### Customize state switch duration

```coffeescript
fe.time = <number>
```

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

Shortcuts are also available:

```coffeescript
layerA.onFocus ->
layerA.onUnfocus ->
layerA.onSelected ->
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

#### Check the currently focused layer
```coffeescript
print fe.focus
```

#### Check whether a layer has focus
```coffeescript
print layerA.focus
```

#### Overriding focus logic
Sometimes you will want to change focus in a way that doesn't make exact geometric sense. For example, when switching from a large header row to a smaller secondary row, you may prefer the first cell in the secondary row receive focus. Or, you may want to provide a way for focus to "loop around" at a row's end. These kinds of functions are possible through _overrides._

Set a layer's overrides using the `overrides` object:
```coffeescript
layerA.overrides =
	up: <layer>
	down: <layer>
	left: <layer>
	right: <layer>
```

It is not necessary to set all four overrides; but only for those directions which require custom behavior. Now, shifting focus from `layerA`  will always land on the direction-specified target -- no matter what FocusEngine thinks should happen.

<img src="https://user-images.githubusercontent.com/935/28783390-d7b1c37e-75d5-11e7-86f3-6a3712430489.png" width="400" style="display: block; margin: auto" alt="Override illustration" />

> Obviously, you can create very counterintuitive behaviors this way. Use with care! 

If a layer has custom overrides, or has been initialized with FocusEngine, you may check any of its current overrides:
```coffeescript
print layerA.overrides?.up
```

The `?` permits the check to fail gracefully on layers which have no overrides.

#### Enable debug mode to log focus changes
```coffeescript
fe.debug = true
```

#### Example project
[Download](https://minhaskamal.github.io/DownGit/#/home?url=https://github.com/bpxl-labs/FocusEngine/tree/master/example.framer) the example to try it for yourself.

#### Known issues

Attempting to perform a `placeFocus()` call as FocusEngine is changing its own focus will fail. (The call is discarded.) If you need to override FocusEngine's logic, use the `overrides` feature or add a slight delay to ensure the call is respected.

```coffeescript
layerA.on "unfocus", ->
	Utils.delay 0.1, ->
		fe.placeFocus(layerB)
```

---

Website: [blackpixel.com](https://blackpixel.com) &nbsp;&middot;&nbsp;
GitHub: [@bpxl-labs](https://github.com/bpxl-labs/) &nbsp;&middot;&nbsp;
Twitter: [@blackpixel](https://twitter.com/blackpixel) &nbsp;&middot;&nbsp;
Medium: [@bpxl-craft](https://medium.com/bpxl-craft)
