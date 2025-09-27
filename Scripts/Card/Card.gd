extends Node2D
class_name Card

## preload for instantiate
static var CardScene = preload("res://Objects/Card.tscn")

## Instantiate a Card scene
static func create():
	var card : Card = CardScene.instantiate()
	return card

## Everythig thats wisible goes here
@onready var display : Node2D = $Display
## For easy access to highlight
@onready var border : Label = $Display/Border
## For interaction with other cards
@onready var csm : CardStateMachine = $StateMachine
## Collider 
@onready var collider : CollisionObject2D = $Collider

## Destination variable for scale
var scale_goal 		:= Vector2.ONE
## Destination variable for roation
var rotation_goal 	:= 0.0
## Destination variable for grapfics position
var display_position_goal 	:= Vector2.ZERO
## Destination variable for graphics rotation
var display_rotation_goal := 0.0
## Destination variable for grapfics scale
var display_scale_goal 		:= Vector2.ONE

## Reference to card handler responsible for this
var handler : CardHandler

## Set up card state machine for all cards
func _ready() -> void:
	csm.init(self)
	Output.print($Collider/Rectangle.shape.size)

func _process(delta: float) -> void:
	## update based on state
	csm.process(delta)
	# lerping all destination variables
	global_scale = lerp(global_scale, scale_goal, 30 * delta)
	global_rotation = lerp_angle(global_rotation,rotation_goal, 5 * delta)
	display.position = lerp(display.position, display_position_goal, 20 * delta)
	display.rotation = lerp_angle(display.rotation,display_rotation_goal, 10 * delta)
	display.scale = lerp(display.scale, display_scale_goal, 30 * delta)
	
func _on_collider_mouse_entered() -> void:
	csm.mouse_entered()

func _on_collider_mouse_exited() -> void:
	csm.mouse_exited()

func _unhandled_input(event: InputEvent):
	csm.input(event)

## Keeps the card in bounds (strict makes card completely wisiblw)
func move_to(goal : Vector2, strict := false):
	if strict:
		goal = goal.clamp(Vector2.ZERO + Global.CARD_DIMENSIONS / 2,
		Global.viewport_rect.size - Global.CARD_DIMENSIONS / 2)
	else:
		goal = goal.clamp(Vector2(), Global.viewport_rect.size)
	var dif = goal - global_position
	display.position = display.position - dif
	global_position = goal

## Rotate card
func rotation(rot : float):
	rotation_goal = rot

## Set cards order in tree
func set_order(ind := -1):
	var count = handler.cards_node.get_child_count()
	handler.cards_node.move_child(self, (count - ind) % count)
