class_name DrawAction
extends Action

var amount : int
var from : CardPile
var to : CardSet

func _init(_amount : int, _from : CardPile, _to : CardSet) -> void:
	amount = _amount
	from = _from
	to = _to
	type = ActionType.DRAW
	

func perform():
	var card = from.draw()
	if card:
		card.display.global_position = from.get_node("background").position + G.card_dimensions / 2
		card.display.scale = Vector2.ZERO
		card.csm.next_state.emit(CardState.StateName.HANDDEFAULT)
		to.add_card(card)
