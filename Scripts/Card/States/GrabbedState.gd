extends CardState

var offset := Vector2.ZERO
var mouse_over := true

func enter(_old_state : CardState):
	mouse_over = true
	card.rotation(0)
	card.z_index = 1001
	card.border.visible = true
	offset = card.global_position - get_global_mouse_position() 
	Output.print(offset)

func exit(_new_state_name : StateName):
	card.set_order(-1)
	card.z_index = 0
	card.border.visible = false
	
func process(_delta : float):
	card.move_to(get_viewport().get_mouse_position() + offset)
	
func input(event : InputEvent):
	if event.is_action_released("Grab"):
		if mouse_over:
			csm.next_state.emit(StateName.HOVERED)
		else:
			csm.next_state.emit(StateName.DEFAULT)

func mouse_entered():
	mouse_over = true
	
func mouse_exited():
	mouse_over = false
