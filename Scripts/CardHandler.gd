extends Node2D
class_name CardHandler

@onready var cards_node = $Cards
@onready var hand : Hand = $Areas/Hand

var default_scale = Vector2(1, 1)

var hovered_cards : Array[Card] = []  # TODO implement a priority que for this

var hovered : Card = null
var grabbed : Card = null
var offset = Vector2()

func _ready() -> void:
	# For testing
	for i in range(7):
		var card = Card.instantiate(self, i)
		cards_node.add_child(card)
		hand.add_card(card)
	hand.update_card_position()

func _process(_delta: float) -> void:
	if grabbed:
		grabbed.set_position_goal(get_global_mouse_position() + offset)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Grab"):
		if hovered_cards:
			grabbed = hovered_cards[0]
			offset = grabbed.global_position - get_global_mouse_position()
			for card : Card in cards_node.get_children():
				if card.index > grabbed.index:
					card.set_index(card.index - 1)
			grabbed.set_index(cards_node.get_child_count())
			grabbed.update_status.emit(Card.CardStatus.GRABBED)
	if event.is_action_released("Grab"):
		if grabbed:
			if hovered_cards.has(grabbed):
				grabbed.update_status.emit(Card.CardStatus.HOVERED)
			else:
				grabbed.update_status.emit(Card.CardStatus.DEFAULT)
			grabbed.release()
			grabbed = null

func calculate_z_index():
	pass

func connect_card_signals(card: Card):
	card.connect(card.mouse_entered.get_name(), mouse_entered_card)
	card.connect(card.mouse_exited.get_name(), mouse_exited_card)
	
func mouse_entered_card(card: Card):
	var ind = 0
	while ind < hovered_cards.size() and card_order(hovered_cards[ind], card):
		ind += 1
	hovered_cards.insert(ind, card)
	if !grabbed and hovered != hovered_cards[0]:
		if hovered:
			hovered.update_status.emit(Card.CardStatus.DEFAULT)
		hovered = hovered_cards[0]
		hovered.update_status.emit(Card.CardStatus.HOVERED)
	
func mouse_exited_card(card: Card):
	hovered_cards.erase(card)
	if card != grabbed:
		card.update_status.emit(Card.CardStatus.DEFAULT)
		if hovered_cards:
			hovered = hovered_cards[0]
			hovered.update_status.emit(Card.CardStatus.HOVERED)
		else:
			hovered = null

func card_order (a : Card, b : Card): 
	return a.index > b.index
