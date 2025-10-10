class_name Battle
extends CanvasItem

@onready var card_handler : CardHandler = $CardHandler 
@onready var action_handler : ActionHandler = $ActionHandler

func _ready() -> void:
	action_handler.add_reaction( Action.ActionType.DRAW, ReshuffleAction.new(card_handler.draw_pile, card_handler.discard_pile), ActionHandler.Timing.PRE)
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Test"):
		var action = DrawAction.new(1, card_handler.draw_pile, card_handler.hand)
		action_handler.add(action)
	if event.is_action_pressed("Test2"):
		var info = CardInfo.new()
		info.art = str("test")
		info.text = str("ind")
		var card = Card.create(info)
		card_handler.play_area.add_child(card)
		card_handler.hand.add_card(card)
