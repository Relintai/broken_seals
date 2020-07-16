# Copyright (c) 2016 KOBUGE Games
# Distributed under the terms of the MIT license.
# https://github.com/KOBUGE-Games/godot-logger/blob/master/LICENSE.md
#
# Upstream repo: https://github.com/KOBUGE-Games/godot-logger

extends Node # Needed to work as a singleton

##================##
## Inner classes  ##
##================##

class Logfile:
	# TODO: Godot doesn't support docstrings for inner classes, GoDoIt (GH-1320)
	# """Class for log files that can be shared between various modules."""
	var file = null
	var path = ""
	var queue_mode = QUEUE_NONE
	var buffer = PoolStringArray()
	var buffer_idx = 0

	func _init(_path, _queue_mode = QUEUE_NONE):
		file = File.new()
		if validate_path(_path):
			path = _path
		queue_mode = _queue_mode
		buffer.resize(FILE_BUFFER_SIZE)

	func get_path():
		return path

	func set_queue_mode(new_mode):
		queue_mode = new_mode

	func get_queue_mode():
		return queue_mode

	func get_write_mode():
		if not file.file_exists(path):
			return File.WRITE # create
		else:
			return File.READ_WRITE # append

	func validate_path(ppath):
		"""Validate the path given as argument, making it possible to write to
		the designated file or folder. Returns whether the path is valid."""
		if !(ppath.is_abs_path() or ppath.is_rel_path()):
			print("[ERROR] [logger] The given path '%s' is not valid." % ppath)
			return false
		var dir = Directory.new()
		var base_dir = ppath.get_base_dir()
		if not dir.dir_exists(base_dir):
			# TODO: Move directory creation to the function that will actually *write*
			dir.open(base_dir)
			var err = dir.make_dir_recursive(base_dir)
			if err:
				print("[ERROR] [logger] Could not create the '%s' directory; exited with error %d." \
						% [base_dir, err])
				return false
			else:
				print("[INFO] [logger] Successfully created the '%s' directory." % base_dir)
		return true

	func flush_buffer():
		"""Flush the buffer, i.e. write its contents to the target file."""
		if buffer_idx == 0:
			return # Nothing to write
		var err = file.open(path, get_write_mode())
		if err:
			print("[ERROR] [logger] Could not open the '%s' log file; exited with error %d." \
					% [path, err])
			return
		file.seek_end()
		for i in range(buffer_idx):
			file.store_line(buffer[i])
		file.close()
		buffer_idx = 0 # We don't clear the memory, we'll just overwrite it

	func write(output, level):
		"""Write the string at the end of the file (append mode), following
		the queue mode."""
		var queue_action = queue_mode
		if queue_action == QUEUE_SMART:
			if level >= WARN: # Don't queue warnings and errors
				queue_action = QUEUE_NONE
				flush_buffer()
			else: # Queue the log, not important enough for "smart"
				queue_action = QUEUE_ALL

		if queue_action == QUEUE_NONE:
			var err = file.open(path, get_write_mode())
			if err:
				print("[ERROR] [logger] Could not open the '%s' log file; exited with error %d." \
						% [path, err])
				return
			file.seek_end()
			file.store_line(output)
			file.close()

		if queue_action == QUEUE_ALL:
			buffer[buffer_idx] = output
			buffer_idx += 1
			if buffer_idx >= FILE_BUFFER_SIZE:
				flush_buffer()

	func get_config():
		return {
			"path": get_path(),
			"queue_mode": get_queue_mode()
		}


class Module:
	# """Class for customizable logging modules."""
	var name = ""
	var output_level = 0
	var output_strategies = []
	var logfile = null

	func _init(_name, _output_level, _output_strategies, _logfile):
		name = _name
		set_output_level(_output_level)

		if typeof(_output_strategies) == TYPE_INT: # Only one strategy, use it for all
			#warning-ignore:unused_variable
			for i in range(0, LEVELS.size()):
				output_strategies.append(_output_strategies)
		else:
			for strategy in _output_strategies: # Need to force deep copy
				output_strategies.append(strategy)

		set_logfile(_logfile)

	func get_name():
		return name

	func set_output_level(level):
		"""Set the custom minimal level for the output of the module.
		All levels greater or equal to the given once will be output based
		on their respective strategies, while levels lower than the given one
		will be discarded."""
		if not level in range(0, LEVELS.size()):
			print("[ERROR] [%s] The level must be comprised between 0 and %d." \
					% [PLUGIN_NAME, LEVELS.size() - 1])
			return
		output_level = level

	func get_output_level():
		return output_level

	func set_common_output_strategy(output_strategy_mask):
		"""Set the common output strategy mask for all levels of the module."""
		if not output_strategy_mask in range(0, MAX_STRATEGY + 1):
			print("[ERROR] [%s] The output strategy mask must be comprised between 0 and %d." \
					% [PLUGIN_NAME, MAX_STRATEGY])
			return
		for i in range(0, LEVELS.size()):
			output_strategies[i] = output_strategy_mask

	func set_output_strategy(output_strategy_mask, level = -1):
		"""Set the output strategy for the given level or (by default) all
		levels of the module."""
		if not output_strategy_mask in range(0, MAX_STRATEGY + 1):
			print("[ERROR] [%s] The output strategy mask must be comprised between 0 and %d." \
					% [PLUGIN_NAME, MAX_STRATEGY])
			return
		if level == -1: # Set for all levels
			for i in range(0, LEVELS.size()):
				output_strategies[i] = output_strategy_mask
		else:
			if not level in range(0, LEVELS.size()):
				print("[ERROR] [%s] The level must be comprised between 0 and %d." \
						% [PLUGIN_NAME, LEVELS.size() - 1])
				return
			output_strategies[level] = output_strategy_mask

	func get_output_strategy(level = -1):
		if level == -1:
			return output_strategies
		else:
			return output_strategies[level]

	func set_logfile(new_logfile):
		"""Set the Logfile instance for the module."""
		logfile = new_logfile

	func get_logfile():
		return logfile

	func get_config():
		return {
			"name": get_name(),
			"output_level": get_output_level(),
			"output_strategies": get_output_strategy(),
			"logfile_path": get_logfile().get_path()
		}


##=============##
##  Constants  ##
##=============##

const PLUGIN_NAME = "logger"

# Logging levels - the array and the integers should be matching
const LEVELS = ["VERBOSE", "DEBUG", "INFO", "WARN", "ERROR"]
const VERBOSE = 0
const DEBUG = 1
const INFO = 2
const WARN = 3
const ERROR = 4

# Output strategies
const STRATEGY_MUTE = 0
const STRATEGY_PRINT = 1
const STRATEGY_FILE = 2
const STRATEGY_MEMORY = 4
const MAX_STRATEGY = STRATEGY_MEMORY*2 - 1

# Output format identifiers
const FORMAT_IDS = {
	"level": "{LVL}",
	"module": "{MOD}",
	"message": "{MSG}"
}

# Queue modes
const QUEUE_NONE = 0
const QUEUE_ALL = 1
const QUEUE_SMART = 2

const FILE_BUFFER_SIZE = 30


##=============##
##  Variables  ##
##=============##

# Configuration
var default_output_level = WARN
# TODO: Find (or implement in Godot) a more clever way to achieve that
var default_output_strategies = [STRATEGY_PRINT, STRATEGY_PRINT, STRATEGY_PRINT, STRATEGY_PRINT, STRATEGY_PRINT]
var default_logfile_path = "user://%s.log" % ProjectSettings.get_setting("application/config/name")
var default_configfile_path = "user://%s.cfg" % PLUGIN_NAME

# e.g. "[INFO] [main] The young alpaca started growing a goatie."
var output_format = "[{LVL}] [{MOD}] {MSG}"

# Specific to STRATEGY_MEMORY
var max_memory_size = 30
var memory_buffer = []
var memory_idx = 0
var memory_first_loop = true
var memory_cache = []
var invalid_memory_cache = false

# Holds default and custom modules and logfiles defined by the user
# Default modules are initialized in _init via add_module
var logfiles = {}
var modules = {}


##=============##
##  Functions  ##
##=============##

func put(level, message, module = "main"):
	"""Log a message in the given module with the given logging level."""
	var module_ref = get_module(module)
	var output_strategy = module_ref.get_output_strategy(level)
	if output_strategy == STRATEGY_MUTE or module_ref.get_output_level() > level:
		return # Out of scope

	var output = format(output_format, level, module, message)

	if output_strategy & STRATEGY_PRINT:
		print(output)

	if output_strategy & STRATEGY_FILE:
		module_ref.get_logfile().write(output, level)

	if output_strategy & STRATEGY_MEMORY:
		memory_buffer[memory_idx] = output
		memory_idx += 1
		invalid_memory_cache = true
		if memory_idx >= max_memory_size:
			memory_idx = 0
			memory_first_loop = false

# Helper functions for each level
# -------------------------------

func verbose(message, module = "main"):
	"""Log a message in the given module with level VERBOSE."""
	put(VERBOSE, message, module)

func debug(message, module = "main"):
	"""Log a message in the given module with level DEBUG."""
	put(DEBUG, message, module)

func info(message, module = "main"):
	"""Log a message in the given module with level INFO."""
	put(INFO, message, module)

func warn(message, module = "main"):
	"""Log a message in the given module with level WARN."""
	put(WARN, message, module)

func error(message, module = "main"):
	"""Log a message in the given module with level ERROR."""
	put(ERROR, message, module)

# Module management
# -----------------

func add_module(name, output_level = default_output_level, \
		output_strategies = default_output_strategies, logfile = null):
	"""Add a new module with the given parameter or (by default) the
	default ones.
	Returns a reference to the instanced module."""
	if modules.has(name):
		info("The module '%s' already exists; discarding the call to add it anew." \
				% name, PLUGIN_NAME)
	else:
		if logfile == null:
			logfile = get_logfile(default_logfile_path)
		modules[name] = Module.new(name, output_level, output_strategies, logfile)
	return modules[name]

func get_module(module = "main"):
	"""Retrieve the given module if it exists; if not, it will be created."""
	if not modules.has(module):
		info("The requested module '%s' does not exist. It will be created with default values." \
				% module, PLUGIN_NAME)
		add_module(module)
	return modules[module]

func get_modules():
	"""Retrieve the dictionary containing all modules."""
	return modules

# Logfiles management
# -------------------

func set_default_logfile_path(new_logfile_path, keep_old = false):
	"""Sets the new default logfile path. Unless configured otherwise with
	the optional keep_old argument, it will replace the logfile for all
	modules which were configured for the previous logfile path."""
	if new_logfile_path == default_logfile_path:
		return # Nothing to do

	var old_logfile = get_logfile(default_logfile_path)
	var new_logfile = null
	if logfiles.has(new_logfile_path): # Already exists
		new_logfile = logfiles[new_logfile_path]
	else: # Create a new logfile
		new_logfile = add_logfile(new_logfile_path)
		logfiles[new_logfile_path] = new_logfile

	if not keep_old: # Replace the old defaut logfile in all modules that used it
		for module in modules.values():
			if module.get_logfile() == old_logfile:
				module.set_logfile(new_logfile)
		logfiles.erase(default_logfile_path)
	default_logfile_path = new_logfile_path

func get_default_logfile_path():
	"""Return the default logfile path."""
	return default_logfile_path

func add_logfile(logfile_path = default_logfile_path):
	"""Add a new logfile that can then be attached to one or more modules.
	Returns a reference to the instanced logfile."""
	if logfiles.has(logfile_path):
		info("A logfile pointing to '%s' already exists; discarding the call to add it anew." \
				% logfile_path, PLUGIN_NAME)
	else:
		logfiles[logfile_path] = Logfile.new(logfile_path)
	return logfiles[logfile_path]

func get_logfile(logfile_path):
	"""Retrieve the given logfile if it exists, otherwise returns null."""
	if not logfiles.has(logfile_path):
		warn("The requested logfile pointing to '%s' does not exist." % logfile_path, PLUGIN_NAME)
		return null
	else:
		return logfiles[logfile_path]

func get_logfiles():
	"""Retrieve the dictionary containing all logfiles."""
	return logfiles

# Default output configuration
# ----------------------------

func set_default_output_strategy(output_strategy_mask, level = -1):
	"""Set the default output strategy mask of the given level or (by
	default) all levels for all modules without a custom strategy."""
	if not output_strategy_mask in range(0, MAX_STRATEGY + 1):
		error("The output strategy mask must be comprised between 0 and %d." \
				% MAX_STRATEGY, PLUGIN_NAME)
		return
	if level == -1: # Set for all levels
		for i in range(0, LEVELS.size()):
			default_output_strategies[i] = output_strategy_mask
		info("The default output strategy mask was set to '%d' for all levels." \
				% [output_strategy_mask], PLUGIN_NAME)
	else:
		if not level in range(0, LEVELS.size()):
			error("The level must be comprised between 0 and %d." % (int(LEVELS.size()) - 1), PLUGIN_NAME)
			return
		default_output_strategies[level] = output_strategy_mask
		info("The default output strategy mask was set to '%d' for the '%s' level." \
				% [output_strategy_mask, LEVELS[level]], PLUGIN_NAME)

func get_default_output_strategy(level):
	"""Get the default output strategy mask of the given level or (by
	default) all levels for all modules without a custom strategy."""
	return default_output_strategies[level]

func set_default_output_level(level):
	"""Set the default minimal level for the output of all modules without
	a custom output level.
	All levels greater or equal to the given once will be output based on
	their respective strategies, while levels lower than the given one will
	be discarded.
	"""
	if not level in range(0, LEVELS.size()):
		error("The level must be comprised between 0 and %d." % (int(LEVELS.size()) - 1), PLUGIN_NAME)
		return
	default_output_level = level
	info("The default output level was set to '%s'." % LEVELS[level], PLUGIN_NAME)

func get_default_output_level():
	"""Get the default minimal level for the output of all modules without
	a custom output level."""
	return default_output_level

# Output formatting
# -----------------

static func format(template, level, module, message):
	var output = template
	output = output.replace(FORMAT_IDS.level, LEVELS[level])
	output = output.replace(FORMAT_IDS.module, module)
	output = output.replace(FORMAT_IDS.message, message)
	return output

func set_output_format(new_format):
	"""Set the output string format using the following identifiers:
	{LVL} for the level, {MOD} for the module, {MSG} for the message.
	The three identifiers should be contained in the output format string.
	"""
	for key in FORMAT_IDS:
		if new_format.find(FORMAT_IDS[key]) == -1:
			error("Invalid output string format. It lacks the '%s' identifier." \
					% FORMAT_IDS[key], PLUGIN_NAME)
			return
	output_format = new_format
	info("Successfully changed the output format to '%s'." % output_format, PLUGIN_NAME)

func get_output_format():
	"""Get the output string format."""
	return output_format

# Strategy "memory"
# -----------------

func set_max_memory_size(new_size):
	"""Set the maximum amount of messages to be remembered when
	using the STRATEGY_MEMORY output strategy."""
	if new_size <= 0:
		error("The maximum amount of remembered messages must be a positive non-null integer. Received %d." \
				% new_size, PLUGIN_NAME)
		return

	var new_buffer = []
	var new_idx = 0
	new_buffer.resize(new_size)

	# Better algorithm welcome :D
	if memory_first_loop:
		var offset = 0
		if memory_idx > new_size:
			offset = memory_idx - new_size
			memory_first_loop = false
		else:
			new_idx = memory_idx
		for i in range(0, min(memory_idx, new_size)):
			new_buffer[i] = memory_buffer[i + offset]
	else:
		var delta = 0
		if max_memory_size > new_size:
			delta = max_memory_size - new_size
		else:
			new_idx = max_memory_size
			memory_first_loop = true
		for i in range(0, min(max_memory_size, new_size)):
			new_buffer[i] = memory_buffer[(memory_idx + delta + i) % max_memory_size]

	memory_buffer = new_buffer
	memory_idx = new_idx
	invalid_memory_cache = true
	max_memory_size = new_size
	info("Successfully set the maximum amount of remembered messages to %d." % max_memory_size, PLUGIN_NAME)

func get_max_memory_size():
	"""Get the maximum amount of messages to be remembered when
	using the STRATEGY_MEMORY output strategy."""
	return max_memory_size

func get_memory():
	"""Get an array of the messages remembered following STRATEGY_MEMORY.
	The messages are sorted from the oldest to the newest."""
	if invalid_memory_cache: # Need to recreate the cached ordered array
		memory_cache = []
		if not memory_first_loop: # else those would be uninitialized
			for i in range(memory_idx, max_memory_size):
				memory_cache.append(memory_buffer[i])
		for i in range(0, memory_idx):
			memory_cache.append(memory_buffer[i])
		invalid_memory_cache = false
	return memory_cache

func clear_memory():
	"""Clear the buffer or remembered messages."""
	memory_buffer.clear()
	memory_idx = 0
	memory_first_loop = true
	invalid_memory_cache = true


# Configuration loading/saving
# ----------------------------

func save_config(configfile = default_configfile_path):
	"""Save the default configuration as well as the set of modules and
	their respective configurations.
	The ConfigFile API is used to generate the config file passed as argument.
	A unique section is used, so that it can be merged in a project's engine.cfg.
	Returns an error code (OK or some ERR_*)."""
	var config = ConfigFile.new()

	# Store default config
	config.set_value(PLUGIN_NAME, "default_output_level", default_output_level)
	config.set_value(PLUGIN_NAME, "default_output_strategies", default_output_strategies)
	config.set_value(PLUGIN_NAME, "default_logfile_path", default_logfile_path)
	config.set_value(PLUGIN_NAME, "max_memory_size", max_memory_size)

	# Logfiles config
	var logfiles_arr = []
	var sorted_keys = logfiles.keys()
	sorted_keys.sort() # Sadly doesn't return the array, so we need to split it
	for logfile in sorted_keys:
		logfiles_arr.append(logfiles[logfile].get_config())
	config.set_value(PLUGIN_NAME, "logfiles", logfiles_arr)

	# Modules config
	var modules_arr = []
	sorted_keys = modules.keys()
	sorted_keys.sort()
	for module in sorted_keys:
		modules_arr.append(modules[module].get_config())
	config.set_value(PLUGIN_NAME, "modules", modules_arr)

	# Save and return the corresponding error code
	var err = config.save(configfile)
	if err:
		error("Could not save the config in '%s'; exited with error %d." \
				% [configfile, err], PLUGIN_NAME)
		return err
	info("Successfully saved the config to '%s'." % configfile, PLUGIN_NAME)
	return OK

func load_config(configfile = default_configfile_path):
	"""Load the configuration as well as the set of defined modules and
	their respective configurations. The expect file contents must be those
	produced by the ConfigFile API.
	Returns an error code (OK or some ERR_*)."""
	# Look for the file
	var dir = Directory.new()
	if not dir.file_exists(configfile):
		warn("Could not load the config in '%s', the file does not exist." % configfile, PLUGIN_NAME)
		return ERR_FILE_NOT_FOUND

	# Load its contents
	var config = ConfigFile.new()
	var err = config.load(configfile)
	if err:
		warn("Could not load the config in '%s'; exited with error %d." \
				% [configfile, err], PLUGIN_NAME)
		return err

	# Load default config
	default_output_level = config.get_value(PLUGIN_NAME, "default_output_level", default_output_level)
	default_output_strategies = config.get_value(PLUGIN_NAME, "default_output_strategies", default_output_strategies)
	default_logfile_path = config.get_value(PLUGIN_NAME, "default_logfile_path", default_logfile_path)
	max_memory_size = config.get_value(PLUGIN_NAME, "max_memory_size", max_memory_size)

	# Load logfiles config and initialize them
	logfiles = {}
	for logfile_cfg in config.get_value(PLUGIN_NAME, "logfiles"):
		var logfile = Logfile.new(logfile_cfg["path"], logfile_cfg["queue_mode"])
		logfiles[logfile_cfg["path"]] = logfile

	# Load modules config and initialize them
	modules = {}
	for module_cfg in config.get_value(PLUGIN_NAME, "modules"):
		var module = Module.new(module_cfg["name"], module_cfg["output_level"], \
				module_cfg["output_strategies"], get_logfile(module_cfg["logfile_path"]))
		modules[module_cfg["name"]] = module

	info("Successfully loaded the config from '%s'." % configfile, PLUGIN_NAME)
	return OK


##=============##
##  Callbacks  ##
##=============##

func _init():
	# Default logfile
	add_logfile(default_logfile_path)
	# Default modules
	add_module(PLUGIN_NAME) # needs to be instanced first
	add_module("main")
	memory_buffer.resize(max_memory_size)

func _exit_tree():
	# Flush non-empty buffers
	var processed_logfiles = []
	var logfile = null
	for module in modules:
		logfile = modules[module].get_logfile()
		if logfile in processed_logfiles:
			continue
		logfile.flush_buffer()
		processed_logfiles.append(logfile)
