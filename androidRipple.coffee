# Module created by Aaron James | November 24th, 2015
#
# Pointer Module by Jordan Dobson is required for this module
# Download and add his module to your modules folder first: http://bit.ly/1lgmNpT
#
# Add the following line to the top of your project:
# android = require "androidRipple"
#
# To add ripple to a layer, use this line of code:
# layerName.on(Events.Click, android.ripple)
# Replace layerName with the name of your layer
#
# Available options:
# You can use any Event with this module

{Pointer} = require "Pointer"

# create ripple function
exports.ripple = (event, layer) ->
	eventCoords = Pointer.offset(event, layer)

	# Change color of ripple
	color = "black"
	animation = curve: "ease-out", time: .4

	# Create layers on Click
	pressFeedback = new Layer
		superLayer: @
		name: "pressFeedback"
		width: layer.width
		height: layer.height
		opacity: 0
		backgroundColor: color
	pressFeedback.states.add
		pressed: opacity: .04
	pressFeedback.states.switch("pressed", animation)

	rippleCircle = new Layer
		superLayer: @
		name: "rippleCircle"
		borderRadius: "50%"
		midX: eventCoords.x
		midY: eventCoords.y
		opacity: .16
		backgroundColor: color
	rippleCircle.states.add
		pressed: scale: layer.width / 60, opacity: 0,
	rippleCircle.states.switch("pressed", animation)

	# Destroy layers after Click
	Utils.delay 0.3, ->
		pressFeedback.states.next("default", animation)
		pressFeedback.on Events.AnimationEnd, ->
			rippleCircle.destroy()
			pressFeedback.destroy()
