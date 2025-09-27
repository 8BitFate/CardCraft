extends Node2D
class_name CardHandler

## All cards live in this node
@onready var cards_node = $Cards
## Ref to hand TODO make it optional
@onready var hand : Hand = $Areas/Hand

## All managed cards (index is z index)
var cards : Array[Card] = []

func _ready() -> void:
	# add cards for testing
	for ind in range(3):
		var card = Card.create()
		card.handler = self
		add_card(card)
		hand.add_card(card)
	hand.update_hand()

## Sets up card to be handled
func add_card(card : Card):
	if card.get_parent() != cards_node:
		cards_node.add_child(card)
	cards.push_back(card)

func _process(_delta: float) -> void:
	pass
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Test"):
		var card = Card.create()
		card.handler = self
		add_card(card)
		hand.add_card(card)
		hand.update_hand()

	
