extends Node2D
class_name CardHandler

@onready var cards_node = $Cards
var screen_size
var default_scale = Vector2(1, 1)

var hovered_cards : Array[Card] = []  # TODO implement a priority que for this

var grabbed : Card = null
var offset = Vector2()

func _ready() -> void:
	screen_size = get_viewport_rect().size
	for card in cards_node.get_children():
		connect_card_signals(card)

func _process(delta: float) -> void:
	if hovered_cards and !grabbed:
		hovered_cards[0].status.emit(Card.CardStatus.HOVERED)
	if grabbed:
		grabbed.global_position_goal = calculate_grabbed_position()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Grab"):
		if hovered_cards:
			grabbed = hovered_cards[0]
			offset = grabbed.global_position - get_global_mouse_position()
			grabbed.status.emit(Card.CardStatus.GRABBED)
	if event.is_action_released("Grab"):
		if grabbed:
			if hovered_cards.has(grabbed):
				grabbed.status.emit(Card.CardStatus.HOVERED)
			else:
				grabbed.status.emit(Card.CardStatus.DEFAULT)
			grabbed = null
			

func connect_card_signals(card: Card):
	card.connect(card.mouse_entered.get_name(), mouse_entered_card)
	card.connect(card.mouse_exited.get_name(), mouse_exited_card)
	
func mouse_entered_card(card: Card):
	var ind = 0
	while ind < hovered_cards.size() and card_order(hovered_cards[ind], card):
		ind += 1
	hovered_cards.insert(ind, card)
	
func mouse_exited_card(card: Card):
	hovered_cards.erase(card)
	if !grabbed:
		card.status.emit(Card.CardStatus.DEFAULT)

func card_order (a : Node2D, b : Node2D): 
	if a.z_index == b.z_index:
		return a.get_index() > b.get_index()
	else:
		return a.z_index > b.z_index
		
func calculate_grabbed_position(goal = get_global_mouse_position()):
	return (goal + offset).clamp(Vector2(), screen_size)
