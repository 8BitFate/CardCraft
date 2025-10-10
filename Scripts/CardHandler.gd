extends CanvasItem
class_name CardHandler

## Ref to hand TODO make it optional
@onready var hand : Hand = $HandArea/Hand
@onready var play_area := $PlayArea
@onready var draw_pile : CardPile = $HandArea/DrawPile
@onready var discard_pile : CardPile = $HandArea/DiscardPile

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func discard(card : Card):
	var info = card.info
	card.info = null
	discard_pile.push_front(info)
	hand.remove_card(card)
	card.queue_free()
