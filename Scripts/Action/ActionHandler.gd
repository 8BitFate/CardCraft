class_name ActionHandler
extends Node

enum Timing {PRE, POST}

var stack : Array[Action] = []

var pre : Dictionary[Action.ActionType, Array] = {}

var post : Dictionary[Action.ActionType, Array] = {}

var timer : Timer

func _ready() -> void:
	timer = Timer.new()
	timer.wait_time = 1.0
	timer.timeout.connect(process_action)
	add_child(timer)
	timer.start()

func _process(_delta: float) -> void:
	pass

func add(action : Action):
	stack.push_back(action)

func process_action():
	if not stack.is_empty():
		var action : Action = stack.back()
		Output.print(action)
		if action.expanded:
			action.perform()
			stack.pop_back()
			if post.has(action.type):
				var reactions = post[action.type]
				for reacrion in reactions:
					stack.push_back(reacrion)
		else:
			if pre.has(action.type):
				var reactions = pre[action.type]
				for reacrion in reactions:
					stack.push_back(reacrion)
			action.expanded = true

func add_reaction(type : Action.ActionType, action : Action, timing := Timing.POST):
	var group = pre
	if timing == Timing.POST:
		group = post
	if not group.has(type):
		group[type] = []
	group[type].append(action)
