extends HandState

func enter(_old_state : CardState):
	super(_old_state)
	
func exit(_new_state_name : StateName):
	super(_new_state_name)

func process(_delta):
	pass

func input(_event : InputEvent):
	pass

func mouse_entered():
	csm.next_state.emit(StateName.HANDHOVERED)
	
func mouse_exited():
	pass
