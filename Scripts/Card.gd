extends Node2D
class_name Card

## preload for instantiate
static var CardScene = preload("res://Objects/Card.tscn")

## Everythig thats wisible goes here
@onready var display = $Display
## For easy access to highlight
@onready var border = $Display/Border

## Mouse enters collider
signal mouse_entered
## Mouse exits collider
signal mouse_exited

## States the card can be in
enum CardStatus {
	DEFAULT, # nothing is happening to the card
	HOVERED, # mouse is hovering over the card
	GRABBED, # card is being dragged
} 

## Signal to tell card what state to change into
signal update_status(status: CardStatus)

# Destination variables for lerping
var global_position_goal : Vector2
var global_rotation_goal : float
var display_position_goal : Vector2
var display_scale_goal : Vector2 = Vector2.ONE
## Stores z_index when it temporarly changes
var z_fallback

## Instantiate a Card scene
static func instantiate(handler : CardHandler = null):
	var card : Card = CardScene.instantiate()
	if handler:
		handler.connect_card(card)
	return card

func _ready() -> void:
	connect(update_status.get_name(), status_handler)
	# for testing
	$Display/Art.text = str(z_fallback)
	name = str(z_fallback)

func _process(delta: float) -> void:
	# lerping all destination variables
	global_position = lerp(global_position, global_position_goal, 15 * delta)
	global_rotation = lerp_angle(global_rotation,global_rotation_goal, 5 * delta)
	display.position = lerp(display.position, display_position_goal, 30 * delta)
	display.scale = lerp(display.scale, display_scale_goal, 30 * delta)
	
func _on_collider_mouse_entered() -> void:
	mouse_entered.emit(self)

func _on_collider_mouse_exited() -> void:
	mouse_exited.emit(self)

## Handles Cards state changes
func status_handler(status: CardStatus):
	match status:
		CardStatus.DEFAULT: 
			display_scale_goal = Vector2.ONE
			display_position_goal = Vector2()
			border.visible = false
			z_index = z_fallback
		CardStatus.HOVERED:
			display_scale_goal = Vector2(Global.UP_SCALE, Global.UP_SCALE)
			display_position_goal = Vector2(0, Global.CARD_HEIGHT - Global.UP_SCALE * Global.CARD_HEIGHT)
			border.visible = false
			z_index = 1000
		CardStatus.GRABBED:
			border.visible = true
			z_index = 1001

## Shorthand for setting z_index and its fallback
func set_z(z: int = 0):
	z_index = z
	z_fallback = z

## Keeps the card in bounds
func set_position_goal(goal : Vector2):
	global_position_goal = goal.clamp(Vector2(), Global.viewport_rect.size)
