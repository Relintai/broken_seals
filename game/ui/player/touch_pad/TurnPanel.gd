extends Node2D

const INACTIVE_IDX = -1;

export (String) var listenerNodePath : String = "../../../../../.."
export (String) var padname : String = ""

var parent : Control

var centerPoint = Vector2(0,0)
var currentForce = Vector2(0,0)
var last_pointer_position : Vector2 = Vector2()

var currentPointerIDX = INACTIVE_IDX;

var listener : Node = null

func _ready():
	parent = get_node("..")
	listener = get_node(listenerNodePath)
	
	if listener != null:
		if not listener.has_method("queue_camera_rotation"):
			listener = null
	
	set_process_input(true)

func get_force():
	return currentForce
	
func _input(event):	
	var incomingPointer = extractPointerIdx(event)

	if incomingPointer == INACTIVE_IDX:
		return
	
	if need2ChangeActivePointer(event):
		if (currentPointerIDX != incomingPointer) and event.is_pressed():
			currentPointerIDX = incomingPointer;
			last_pointer_position = Vector2(event.position.x - parent.get_global_rect().position.x, event.position.y - parent.get_global_rect().position.y);
			
			get_tree().set_input_as_handled()

	var theSamePointer = currentPointerIDX == incomingPointer
	if isActive() and theSamePointer:
		process_input(event)

func need2ChangeActivePointer(event): #touch down inside analog	
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		return parent.get_global_rect().has_point(Vector2(event.position.x, event.position.y))
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
	calculateForce(event.position.x - parent.get_global_rect().position.x, event.position.y - parent.get_global_rect().position.y)

	var isReleased = isReleased(event)
	if isReleased:
		reset()
		
	get_tree().set_input_as_handled()


func reset():
	currentPointerIDX = INACTIVE_IDX
	##calculateForce(0, 0)
	last_pointer_position = Vector2()
	
func calculateForce(var x, var y):
	var v : Vector2 = Vector2(x, y)
	currentForce = last_pointer_position - v
	last_pointer_position = v
	
	sendSignal2Listener()

func sendSignal2Listener():
	if (listener != null):
#		listener.analog_force_change(currentForce, self)
		listener.queue_camera_rotation(currentForce)

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

