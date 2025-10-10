extends Control

@onready var viewport := get_viewport()
@onready var window := get_window()
@onready var viewport_rect := get_viewport_rect()

var card_dimensions : Vector2

func _ready() -> void:
	window.size_changed.connect(resize)
	resize()

func _process(_delta: float) -> void:
	pass

func resize():
	var card_width = window.size.x / 6.0
	card_dimensions = Vector2(card_width, card_width / 0.625)
	var cards = find_children("", "Card", true, false)
	# Output.print(cards)
	for card in cards:
		card.resize()
