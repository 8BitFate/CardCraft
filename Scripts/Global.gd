extends Node

## Constants
const CARD_WIDTH = 120
const CARD_HEIGHT = 200
const CARD_DIMENSIONS = Vector2(CARD_WIDTH, CARD_HEIGHT)
const UP_SCALE = 1.05

## Global variables 
@onready var viewport_rect = get_viewport().get_visible_rect()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
