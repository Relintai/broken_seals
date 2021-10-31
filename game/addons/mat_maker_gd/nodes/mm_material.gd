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
var job : ThreadPoolExecuteJob = ThreadPoolExecuteJob.new()

func initialize():
	if !initialized:
		initialized = true
		
		job.setup(self, "_thread_func")
		
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
	job.cancelled = false
	
	if rendering:
		queued_render = true
		return
		
	if !initialized:
		initialize()
	
	if !ThreadPool.has_job(job):
		ThreadPool.add_job(job)

func _thread_func() -> void:
	if job.cancelled:
		rendering = false
		return
	
	rendering = true
	job.cancelled = false
	
	var did_render : bool = true
		
	while did_render:
		did_render = false
		
		for n in nodes:
			if n && n.render(self):
				did_render = true
				
			if job.cancelled:
				rendering = false
				return
				
	rendering = false
	
	if queued_render:
		queued_render = false
		_thread_func()

func cancel_render_and_wait() -> void:
	if rendering:
		ThreadPool.cancel_task_wait(job)
		
		job.cancelled = false
		
		pass

func on_node_changed() -> void:
	call_deferred("render")
