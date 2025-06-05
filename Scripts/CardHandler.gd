extends Node2D
class_name CardHandler

@onready var cards = $Cards
var screen_size
var lastevent
var multiselect = false
var multigrab_hit = false
var multigrab_list = []
var cursor_pos = Vector2()

enum Shape {NOTHING, STACK, TILE, FAN}

var current_shape : Shape = Shape.NOTHING

func _ready() -> void:
	screen_size = get_viewport_rect().size
	for i in 10:
		var card = Card.instantiate()
		cards.add_child(card)
		card.update_handler()

func _process(delta: float) -> void:
	multigrab_hit = false
	var selected = get_selected()
	if Shape.STACK == current_shape:
		stack(selected, cursor_mod())
	elif Shape.TILE == current_shape:
		tile(selected, cursor_mod())
	elif Shape.FAN == current_shape:
		fan(selected, cursor_mod())

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Stack Cards"):
		cursor_pos = get_global_mouse_position()
		current_shape = Shape.STACK
	elif event.is_action_pressed("Tile Cards"):
		cursor_pos = get_global_mouse_position()
		current_shape = Shape.TILE
	elif event.is_action_pressed("Fan Cards"):
		cursor_pos = get_global_mouse_position()
		current_shape = Shape.FAN
	elif event.is_action_pressed("Invert Cards"):
		invert(get_selected())
	if event.is_action_released("Stack Cards") \
	or event.is_action_released("Tile Cards") \
	or event.is_action_released("Fan Cards"):
		current_shape = Shape.NOTHING
	
func cursor_mod():
	return get_global_mouse_position() - cursor_pos

func stack(cards, mod):
	print(mod)
	var len = cards.size()
	if 1 == len:
		cards[0].offset = Vector2()
	else:
		for ind in len:
			var card : Card = cards[ind]
			card.offset = mod / (len - 1) * ind
			card.end_rotation = 0
			card.calculate_offset(cursor_pos)

func fan(cards, mod):
	var len = cards.size()
	for ind in len:
		var card : Card = cards[ind]
		card.offset = Vector2(
			Game.CARD_WIDTH * 0.6 * (mod.x + 100) / 100 * ind, 
			cos(0.1 * PI +  1.8 * PI * float(ind + 1)
			 / float(len + 1)) * Game.CARD_HEIGHT * (mod.y + 50) / 1000 * len 
		)
		card.calculate_offset(cursor_pos)
		var rot = PI / 3 * (-mod.x + 200) / 200
		card.end_rotation = (rot / (len + 1) * (ind + 1)) - rot / 2
		

func tile(cards, mod):
	var dim : int = ceil(sqrt(cards.size()))
	var ratio = float(Game.CARD_WIDTH) / float(Game.CARD_HEIGHT)
	for ind in cards.size():
		var card = cards[ind]
		card.offset = Vector2(
			Game.CARD_WIDTH * 1.1 * (mod.x + 200) / 200 * (ind % dim), 
			Game.CARD_HEIGHT * 1.06 * (mod.y + 200) / 200 * (ind / dim)
		)
		card.calculate_offset(cursor_pos)
		card.end_rotation = 0

func invert(cards: Array):
	cards.reverse()
	for card in cards:
		card.top()
	
func multigrab():
	multigrab_hit = true
	for card in multigrab_list:
		card.grab(false)
	multigrab_list = []
	
func multigrab_cancel ():
	multiselect = false
	if multigrab_list:
		for card in get_selected():
			card.deselect()
		multigrab_list = []

func get_selected():
	return cards.get_children().filter(func (card):
		if card is Card:
			return card.selected
		else:
			return false
		)

func first(event: InputEvent):
	if event.is_match(lastevent):
		return false
	else:
		lastevent = event
		return true
