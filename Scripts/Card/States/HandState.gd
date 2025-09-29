class_name HandState
extends CardState

var hand : Hand
var con : Callable

func enter(old_state : CardState):
	hand = card.handler.hand
	if old_state is HandState:
		con = old_state.con
		hand.update.emit()
	else:
		con = update
		hand.update.connect(con)
		hand.add_card(card)
	
func exit(new_state_name : StateName):
	var new_state = csm.get_state(new_state_name)
	if not new_state is HandState:
		hand.update.disconnect(con)
		hand.remove_card(card)

func process(_delta):
	pass

func input(_event : InputEvent):
	pass

func mouse_entered():
	pass
		
func mouse_exited():
	pass

func update ():
	var ind = hand.cards.find(card)
	card.move_to(hand.card_pos(ind))
	card.set_order(ind)
