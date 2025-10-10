extends Control
class_name Card

## preload for instantiate
static var CardScene = preload("res://Objects/Card.tscn")

## Instantiate a Card scene
static func create(data : CardInfo):
	var card : Card = CardScene.instantiate()
	card.info = data
	return card

## Everythig thats wisible goes here
@onready var display : Control = $Display
## For interaction with other cards
@onready var csm : CardStateMachine = $StateMachine

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

@export var info : CardInfo

## Set up card state machine for all cards
func _ready() -> void:
	csm.init(self)
	#display.get_node("Description").text = info.text
	#display.get_node("Art").text = info.art
	resize()

func _process(delta: float) -> void:
	## update based on state
	csm.process(delta)
	# lerping all destination variables
	# global_scale = lerp(global_scale, scale_goal, 30 * delta)
	# global_rotation = lerp_angle(global_rotation,rotation_goal, 5 * delta)
	#display.position = lerp(display.position, display_position_goal, 5 * delta)
	#display.rotation = lerp_angle(display.rotation,display_rotation_goal, 5 * delta)
	#display.scale = lerp(display.scale, display_scale_goal, 5 * delta)

func _on_collider_mouse_entered() -> void:
	csm.mouse_entered()

func _on_collider_mouse_exited() -> void:
	csm.mouse_exited()

func _unhandled_input(event: InputEvent):
	csm.input(event)

func resize():
	var width = G.card_dimensions.x
	size.x = width
	size.y = width / 0.625

## Keeps the card in bounds
func move_to(goal : Vector2):
	goal = goal.clamp(Vector2(), G.viewport_rect.size)
	var pos = display.global_position 
	global_position = goal
	display.global_position = pos

## Rotate card
func rotation(rot : float):
	rotation_goal = rot

## Set cards order in tree
func set_order(ind : int):
	z_index = ind
