tool
class_name MMMateial
extends Resource

#threads are implemented using my thread pool engine module.
#if you want to use this without that module in your engine set this to false,
#and comment out the lines that give errors
const USE_THREADS = true

export(Vector2) var image_size : Vector2 = Vector2(128, 128)
export(Array) var nodes : Array

var initialized : bool = false
var rendering : bool = false
var queued_render : bool = false
var render_cancelled : bool = false

func initialize():
	if !initialized:
		initialized = true
		
		for n in nodes:
			n.connect("changed", self, "on_node_changed")

func add_node(node : MMNode) -> void:
	nodes.append(node)
	
	node.connect("changed", self, "on_node_changed")
	
	emit_changed()
	
func remove_node(node : MMNode) -> void:
	if !node:
		return
	
	for op in node.output_properties:
		for n in nodes:
			if n:
				for ip in n.input_properties:
						if ip.input_property == op:
							ip.set_input_property(null)
	
	nodes.erase(node)
	
	node.disconnect("changed", self, "on_node_changed")
	
	emit_changed()

func render() -> void:
	if USE_THREADS:
		render_threaded()
	else:
		render_non_threaded()
	
func render_non_threaded() -> void:
	if !initialized:
		initialize()
		
	var did_render : bool = true
		
	while did_render:
		did_render = false
		
		for n in nodes:
			if n && n.render(self):
				did_render = true

func render_threaded() -> void:
	if rendering:
		queued_render = true
		return
		
	if !initialized:
		initialize()
	
	var j : ThreadPoolExecuteJob = ThreadPoolExecuteJob.new()
	j.setup(self, "_thread_func")
	
	ThreadPool.add_job(j)

func _thread_func() -> void:
	if render_cancelled:
		rendering = false
		return
	
	rendering = true
	render_cancelled = false
	
	var did_render : bool = true
		
	while did_render:
		did_render = false
		
		for n in nodes:
			if n && n.render(self):
				did_render = true
				
			if render_cancelled:
				rendering = false
				return
				
	rendering = false
	
	if queued_render:
		queued_render = false
		_thread_func()

func on_node_changed() -> void:
	call_deferred("render")
