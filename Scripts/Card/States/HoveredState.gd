extends CardState

func enter():
	card.display_scale_goal = Vector2(Global.UP_SCALE, Global.UP_SCALE)
	card.display_position_goal = Vector2(0, Global.CARD_HEIGHT - Global.UP_SCALE * Global.CARD_HEIGHT)
	card.display_rotation_goal = -1 * card.rotation_goal
	card.z_index = 1000

func exit():
	card.display_scale_goal = Vector2.ONE
	card.display_position_goal = Vector2.ZERO
	card.display_rotation_goal = 0.0
	card.z_index = 0
	
func process(_delta : float):
	pass
	
func input(event : InputEvent):
	if event.is_action_pressed("Grab"):
		csm.next_state.emit(StateName.GRABBED)

func mouse_entered():
	pass
	
func mouse_exited():
	csm.next_state.emit(StateName.DEFAULT)
