class_name ReshuffleAction
extends Action

var from : CardSet
var to : CardSet
var check : bool

func _init(_to : CardSet, _from : CardSet, check_empty := true) -> void:
	from = _from
	to = _to
	check = check_empty
	type = ActionType.RESHUFFLE

func perform():
	if (check and to.size() == 0) or not check:
		## TODO random number system
		for card in from.cards:
			from.remove_card(card)
			to.add_card(card)
