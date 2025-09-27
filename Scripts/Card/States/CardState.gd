class_name CardState
extends Node

## reference to card with this state
var card : Card

## reference to state machine
var csm : CardStateMachine

## all possible states
enum StateName {DEFAULT, HOVERED, GRABBED}

## State name (form enum)
@export var state_name : StateName

## Set up refferences
func init(_card : Card, _csm : CardStateMachine):
	card = _card
	csm = _csm

func enter():
	pass

func exit():
	pass
	
func process(_delta : float):
	pass
	
func input(_event : InputEvent):
	pass

func mouse_entered():
	pass
	
func mouse_exited():
	pass
