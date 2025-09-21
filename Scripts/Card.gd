extends Node2D
class_name Card

static var CardScene = preload("res://Objects/Card.tscn")

@onready var display = $Display
@onready var border = $Display/Border
@onready var collider = $Collider

signal mouse_entered
signal mouse_exited
signal released

enum CardStatus {
	DEFAULT, # nothing is happening to the card
	HOVERED, # mouse is hovering over the card
	GRABBED, # card is being dragged
} 

signal update_status(status: CardStatus)

# Destination variables for lerping
var global_position_goal : Vector2
var global_rotation_goal : float
var display_position_goal : Vector2
var display_scale_goal : Vector2 = Vector2.ONE
var index

## Instantiate a Card scene
static func instantiate(handler : CardHandler = null, z_ind : int = 0):
	var card : Card = CardScene.instantiate()
	if handler:
		handler.connect_card_signals(card)
	card.set_index(z_ind)
	card.name = str(z_ind)
	return card

func _ready() -> void:
	connect(update_status.get_name(), status_handler)
	global_position_goal = global_position
	$Display/Art.text = str(z_index)

func _process(delta: float) -> void:
	global_position = lerp(global_position, global_position_goal, 15 * delta)
	global_rotation = lerp_angle(global_rotation,global_rotation_goal, 15 * delta)
	display.position = lerp(display.position, display_position_goal, 30 * delta)
	display.scale = lerp(display.scale, display_scale_goal, 30 * delta)
	
func _on_collider_mouse_entered() -> void:
	mouse_entered.emit(self)

func _on_collider_mouse_exited() -> void:
	mouse_exited.emit(self)
	
func release():
	released.emit(self)

func status_handler(status: CardStatus):
	match status:
		CardStatus.DEFAULT: 
			display_scale_goal = Vector2.ONE
			display_position_goal = Vector2()
			border.visible = false
			z_index = index
		CardStatus.HOVERED:
			display_scale_goal = Vector2(Global.UP_SCALE, Global.UP_SCALE)
			display_position_goal = Vector2(0, Global.CARD_HEIGHT - Global.UP_SCALE * Global.CARD_HEIGHT)
			border.visible = false
			z_index = 1000
		CardStatus.GRABBED:
			border.visible = true
			z_index = 1001

func set_index(z: int = 0):
	z_index = z
	index = z

func set_position_goal(goal : Vector2):
	global_position_goal = goal.clamp(Vector2(), Global.viewport_rect.size)
