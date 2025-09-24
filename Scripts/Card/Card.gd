extends Node2D
class_name Card

## preload for instantiate
static var CardScene = preload("res://Objects/Card.tscn")

## Instantiate a Card scene
static func create():
	var card : Card = CardScene.instantiate()
	return card

## Everythig thats wisible goes here
@onready var display = $Display
## For easy access to highlight
@onready var border = $Display/Border

## Mouse enters collider
signal mouse_entered
## Mouse exits collider
signal mouse_exited

## Destination variable for position
var global_position_goal 	:= Vector2.ZERO
## Destination variable for scale
var global_scale_goal 		:= Vector2.ONE
## Destination variable for roation
var global_rotation_goal 	:= 0.0
## Destination variable for grapfics position
var display_position_goal 	:= Vector2.ZERO
## Destination variable for grapfics scale
var display_scale_goal 		:= Vector2.ONE
## Stores z_index when it temporarly changes
var z_fallback := 0

func _ready() -> void:
	# connect(update_status.get_name(), status_handler)
	# for testing
	name = str(z_fallback)
	$Display/Art.text = str(z_fallback)

func _process(delta: float) -> void:
	# lerping all destination variables
	global_position = lerp(global_position, global_position_goal, 15 * delta)
	global_scale = lerp(global_scale, global_scale_goal, 30 * delta)
	global_rotation = lerp_angle(global_rotation,global_rotation_goal, 5 * delta)
	display.position = lerp(display.position, display_position_goal, 30 * delta)
	display.scale = lerp(display.scale, display_scale_goal, 30 * delta)
	
func _on_collider_mouse_entered() -> void:
	mouse_entered.emit(self)

func _on_collider_mouse_exited() -> void:
	mouse_exited.emit(self)

## Handles Cards state changes
#func status_handler(status: CardStatus):
	#match status:
		#CardStatus.DEFAULT: 
			#display_scale_goal = Vector2.ONE
			#display_position_goal = Vector2()
			#border.visible = false
			#z_index = z_fallback
		#CardStatus.HOVERED:
			#display_scale_goal = Vector2(Global.UP_SCALE, Global.UP_SCALE)
			#display_position_goal = Vector2(0, Global.CARD_HEIGHT - Global.UP_SCALE * Global.CARD_HEIGHT)
			#border.visible = false
			#z_index = 1000
		#CardStatus.GRABBED:
			#border.visible = true
			#z_index = 1001

## Shorthand for setting z_index and its fallback
func set_z(z: int = 0):
	z_index = z
	z_fallback = z

## Keeps the card in bounds
func set_position_goal(goal : Vector2):
	global_position_goal = goal.clamp(Vector2(), Global.viewport_rect.size)
