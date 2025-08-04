extends Node2D
class_name Card

static var CardScene = preload("res://Objects/Card.tscn")

@onready var display = $Display
@onready var border = $Display/Border
@onready var collider = $Collider

signal mouse_entered
signal mouse_exited

var is_highlighted = false
var is_grabbed = false

static func instantiate():
	return CardScene.instantiate()

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	z_index = 1
	display.scale = Vector2.ONE
	display.position = Vector2()
	border.visible = false
	if is_highlighted and !is_grabbed:
		z_index = 2
		display.scale = Vector2(Game.UP_SCALE, Game.UP_SCALE)
		display.position = Vector2(0, Game.CARD_HEIGHT - Game.UP_SCALE * Game.CARD_HEIGHT)
	if is_grabbed:
		z_index = 2
		border.visible = true
	
func _on_collider_mouse_entered() -> void:
	mouse_entered.emit(self)

func _on_collider_mouse_exited() -> void:
	mouse_exited.emit(self)
