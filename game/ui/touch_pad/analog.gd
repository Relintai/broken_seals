extends Node2D

# This is by someone else TODO check!

const INACTIVE_IDX = -1;
export var isDynamicallyShowing = false
export (String) var listenerNodePath : String = "../../../../../../.."
export var padname = ""

var ball
var bg 
var animation_player
var parent
var listenerNode

var centerPoint = Vector2(0,0)
var currentForce = Vector2(0,0)
var halfSize = Vector2()
var ballPos = Vector2()
var squaredHalfSizeLength = 0
var currentPointerIDX = INACTIVE_IDX;

func _ready():
	set_process_input(true)
	bg = get_node("bg")
	ball = get_node("ball")	
	animation_player = get_node("AnimationPlayer")
	parent = get_parent()
	halfSize = bg.texture.get_size()/2
	squaredHalfSizeLength = halfSize.x * halfSize.y
	
	if (listenerNodePath != "" && listenerNodePath!=null):
		listenerNode = get_node(listenerNodePath)
	elif listenerNodePath=="":
		listenerNode = null

#	isDynamicallyShowing = isDynamicallyShowing and parent extends Control
	if isDynamicallyShowing:
		modulate.a = 0
#		hide()

func get_force():
	return currentForce
	
func _unhandled_input(event):
	
	var incomingPointer = extractPointerIdx(event)
	#print(incomingPointer)
	
	if incomingPointer == INACTIVE_IDX:
		return
	
	if need2ChangeActivePointer(event):
		if (currentPointerIDX != incomingPointer) and event.is_pressed():
			currentPointerIDX = incomingPointer;
			showAtPos(Vector2(event.position.x, event.position.y));
			get_tree().set_input_as_handled()

	var theSamePointer = currentPointerIDX == incomingPointer
	if isActive() and theSamePointer:
		process_input(event)

func need2ChangeActivePointer(event): #touch down inside analog	
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if isDynamicallyShowing:
			#print(get_parent().get_global_rect())
			return get_parent().get_global_rect().has_point(Vector2(event.position.x, event.position.y))
		else:
			var length = (global_position - Vector2(event.position.x, event.position.y)).length_squared();
			return length < squaredHalfSizeLength
	else:
		return false

func isActive():
	return currentPointerIDX != INACTIVE_IDX

func extractPointerIdx(event):
	var touch = event is InputEventScreenTouch
	var drag = event is InputEventScreenDrag
	var mouseButton = event is InputEventMouseButton
	var mouseMove = event is InputEventMouseMotion
	
	#print(event)
	if touch:
		return event.index
	
	elif drag:
		
		
		return event.index
	elif mouseButton or mouseMove:
		#plog("SOMETHING IS VERYWRONG??, I HAVE MOUSE ON TOUCH DEVICE")
		return INACTIVE_IDX
	else:
		return INACTIVE_IDX
		
func process_input(event):
	calculateForce(event.position.x - global_position.x, event.position.y - global_position.y)
	updateBallPos()
	
	var isReleased = isReleased(event)
	if isReleased:
		reset()
		
	get_tree().set_input_as_handled()


func reset():
	currentPointerIDX = INACTIVE_IDX
	calculateForce(0, 0)

	if isDynamicallyShowing:
		hide()
	else:
		updateBallPos()

func showAtPos(pos):
	if isDynamicallyShowing:
		animation_player.play("alpha_in", 0.2)
		global_position = pos
	
func hide():
	animation_player.play("alpha_out", 0.2) 

func updateBallPos():
	ballPos.x = halfSize.x * currentForce.x #+ halfSize.x
	ballPos.y = halfSize.y * -currentForce.y #+ halfSize.y
	ball.position = Vector2(ballPos.x, ballPos.y)

func calculateForce(var x, var y):
	#get direction
	currentForce.x = (x - centerPoint.x)/halfSize.x
	currentForce.y = -(y - centerPoint.y)/halfSize.y
	#print(currentForce.x, currentForce.y)
	#limit 
	#print(currentForce.length_squared())
	if currentForce.length_squared()>1:
		currentForce=currentForce/currentForce.length()
	
	sendSignal2Listener()

func sendSignal2Listener():
	if (listenerNode != null):
		listenerNode.analog_force_change(currentForce, self)

func isPressed(event):
	if event is InputEventMouseMotion:
		return (InputEventMouse.button_mask == 1)
	elif event is InputEventScreenTouch:
		return event.is_pressed()

func isReleased(event):
	if event is InputEventScreenTouch:
		return !event.is_pressed()
	elif event is InputEventMouseButton:
		return !event.is_pressed()
