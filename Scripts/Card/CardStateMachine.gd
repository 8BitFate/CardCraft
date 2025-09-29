class_name CardStateMachine
extends Node

## Signal to tell card what state to change into
signal next_state(state: CardState)

## Starting state of state automaton
var initial_state_name : CardState.StateName = CardState.StateName.DEFAULT
## Current state
var state : CardState
## reference to handled card
var card : Card

## Dict connecting state names to state objects
var states : Dictionary [CardState.StateName, CardState] = {}
## Data persisted between states
var data = {}

func _ready():
	next_state.connect(update_state)

## set up state dict and enter initial state
func init(_card : Card):
	card = _card
	for child in get_children():
		if child is CardState:
			child.init(card, self)
			if states.get(child.state_name, null):
				print("Multiple states for same name")
			else:
				states[child.state_name] = child
	update_state(initial_state_name)

## Get state object corresponding to state name
func get_state(state_name : CardState.StateName):
	return states[state_name]

## leave current state enter next state
func update_state(state_name : CardState.StateName):
	var new_state = get_state(state_name)
	if state == new_state:
		return
	if state:
		state.exit(state_name)
	new_state.enter(state)
	state = new_state

func process(delta : float):
	if state:
		state.process(delta)
	
func input(event : InputEvent):
	if state:
		state.input(event)

func mouse_entered():
	if state:
		state.mouse_entered()

func mouse_exited():
	if state:
		state.mouse_exited()
