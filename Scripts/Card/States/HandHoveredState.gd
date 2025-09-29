extends HandState

func enter(old_state : CardState):
	super(old_state)
	card.z_index = 1000

func exit(new_state_name : StateName):
	super(new_state_name)
	card.z_index = 0
	
func process(_delta : float):
	pass
	
func input(event : InputEvent):
	if event.is_action_pressed("Grab"):
		csm.next_state.emit(StateName.GRABBED)
	if event.is_action_pressed("Action"):
		card.handler.discard(card)

func mouse_entered():
	pass
	
func mouse_exited():
	csm.next_state.emit(StateName.HANDDEFAULT)
	
