extends Node2D
class_name Card

static var CardScene = preload("res://Objects/Card.tscn")

@onready var display = $Display
@onready var border = $Display/Border
@onready var collider = $Collider

signal mouse_entered
signal mouse_exited

enum CardStatus {
	DEFAULT, # nothing is happening to the card
	HOVERED, # mouse is hovering over the card
	GRABBED, # card is being dragged
} 

signal update_status(status: CardStatus)

# Destination variables for lerping
var global_position_goal : Vector2
var display_position_goal : Vector2
var display_scale_goal : Vector2 = Vector2.ONE

## Instantiate a Card scene
static func instantiate():
	return CardScene.instantiate()

func _ready() -> void:
	connect(update_status.get_name(), status_handler)
	global_position_goal = global_position

func _process(delta: float) -> void:
	global_position = lerp(global_position, global_position_goal, 15 * delta)
	display.position = lerp(display.position, display_position_goal, 30 * delta)
	display.scale = lerp(display.scale, display_scale_goal, 30 * delta)
	
func _on_collider_mouse_entered() -> void:
	mouse_entered.emit(self)

func _on_collider_mouse_exited() -> void:
	mouse_exited.emit(self)

func status_handler(status: CardStatus):
	match status:
		CardStatus.DEFAULT: 
			z_index = 1
			display_scale_goal = Vector2.ONE
			display_position_goal = Vector2()
			border.visible = false
		CardStatus.HOVERED:
			z_index = 2
			display_scale_goal = Vector2(Game.UP_SCALE, Game.UP_SCALE)
			display_position_goal = Vector2(0, Game.CARD_HEIGHT - Game.UP_SCALE * Game.CARD_HEIGHT)
			border.visible = false
		CardStatus.GRABBED:
			border.visible = true
			z_index = 2
