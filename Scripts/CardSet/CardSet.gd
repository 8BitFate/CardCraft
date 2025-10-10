class_name CardSet
extends CanvasItem

var cards : Array[Card] = []
var cards_node : CanvasItem

func _ready() -> void:
	cards_node = Node2D.new()

func add_card(card : Card):
	card.reparent(cards_node, true)
	cards.push_back(card)

func remove_card(card : Card):
	cards.erase(card)
	cards_node.remove_child(card)

func size():
	return cards.size()
