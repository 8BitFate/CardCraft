extends CardState

func enter():
	pass

func exit():
	pass

func process(_delta):
	pass
	
func input(_event : InputEvent):
	pass

func mouse_entered():
	csm.next_state.emit(StateName.HOVERED)
	
func mouse_exited():
	pass
