class_name CardPile
extends CardSet

func _ready() -> void:
	super()
	cards_node.hide()
	
func draw():
	Output.print(size())
	if cards.size() > 0:
		var card = cards[0]
		remove_card(card)
		return card
	else:
		return null

func add_card(card : Card):
	super(card)
	Output.print(size())
