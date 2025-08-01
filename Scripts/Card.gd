extends Node2D
class_name Card

static var CardScene = preload("res://Objects/Card.tscn")

const UP_SCALE = 1.05
@onready var display = $Display
@onready var border = $Display/Border
@onready var end_position = self.global_position
@onready var end_rotation = self.global_rotation

var default_scale = Vector2(1, 1)
var mouseover = false
var offset = Vector2()
var grabbed = false
var selected = false
var handler: CardHandler

static func instantiate(edit_state = 0):
	return CardScene.instantiate(edit_state)

func _init(_handler = null) -> void:
	if handler:
		self.handler = handler
		
func _ready() -> void:
	if not handler:
		update_handler()
	var size = $Display/Background.size
	default_scale = Vector2(Game.CARD_WIDTH / size.x, Game.CARD_HEIGHT / size.y)
	scale = default_scale

func _process(delta: float) -> void:
	if grabbed:
		calculate_offset()
	global_position = lerp(global_position, end_position, 15 * delta)
	global_rotation = lerp_angle(global_rotation, end_rotation, 10 * delta)
	if mouseover and handler.Shape.NOTHING == handler.current_shape:
		display.scale = Vector2(UP_SCALE, UP_SCALE)
		display.position = Vector2(0, Game.CARD_HEIGHT - UP_SCALE * Game.CARD_HEIGHT)
	else:
		display.scale = Vector2.ONE
		display.position = Vector2()

func _on_collider_mouse_entered() -> void:
	mouseover = true

func _on_collider_mouse_exited() -> void:
	mouseover = false

func _unhandled_input(event: InputEvent) -> void:
	if mouseover:
		if event.is_action_pressed("Multy Select"):
			if handler.first(event):
				select()
				grab(false)
				handler.multiselect = true
				handler.multigrab()
			else:
				if selected:
					grab(false)
					handler.multigrab()
		elif event.is_action_pressed("Select"):
			if selected:
				grab(false)
				handler.multigrab()
			else:
				if handler.first(event):
					handler.multigrab_cancel()
					select()
					grab()
	if selected and event.is_action_released("Select"):
		ungrab()
		handler.lastevent = null
		
func grab(reset_rotation = true):
	# print("grabbed " + self.name)
	grabbed = true
	if reset_rotation:
		end_rotation = 0
	offset = global_position - get_global_mouse_position()

func ungrab():
	# print("ungrabbed " + self.name)
	grabbed = false

func select(_top = true):
	# print("selected " + self.name)
	selected = true
	border.visible = true
	if top:
		top()
		
func top():
	get_parent().move_child(self, -1)
	
func deselect():
	# print("deselected " + self.name)
	selected = false
	border.visible = false
	offset = Vector2()

func update_handler(_handler: CardHandler = null):
	if not handler:
		self.handler = find_parent("CardHandler")
	else:
		self.handler = handler

func calculate_offset(_offset = get_global_mouse_position()):
	var end = offset + self.offset
	end_position = end.clamp(Vector2(), handler.screen_size)
