class_name CardStateMachine
extends Node

## Signal to tell card what state to change into
signal next_state(state: CardState)

@export var initial_state : CardState

var state : CardState

func init(card : Card):
	next_state.connect(update_state)
	for child in get_children():
		if child is CardState:
			child.card = card
			child.machine = self
		if initial_state:
			initial_state.enter()
			state = initial_state

func update_state(new_state : CardState):
	if state == new_state:
		return
	if state:
		state.exit()
	new_state.enter()
	state = new_state
	
func on_input(event : InputEvent):
	if state:
		state.on_input(event)
