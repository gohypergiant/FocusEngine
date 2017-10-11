############################################
# Example usage.
# For all features, please check the README.
############################################

focusContainer = new Layer
	width: 440
	height: 80
	x: Align.center
	y: Align.center
	backgroundColor: "clear"
for i in [0..4]
	i = new TextLayer
		parent: focusContainer
		x: i * 90
		backgroundColor: new Color("hsl(#{200 + i * 10}, 95, 57)")
		width: 80
		height: 80
		borderRadius: 10
		text: i
		color: "white"
		textAlign: "center"

document.addEventListener "keydown", (event) ->
	keyCode = event.which
	switch keyCode
		when 13 then fe.changeFocus("select")
		when 37 then fe.changeFocus("left")
		when 38 then fe.changeFocus("up")
		when 39 then fe.changeFocus("right")
		when 40 then fe.changeFocus("down")
		else null

fe.time = 0.5
fe.initialize(focusContainer.children)
fe.placeFocus(focusContainer.children[0])

for layer in focusContainer.children
	layer.onTap -> fe.placeFocus(this)
