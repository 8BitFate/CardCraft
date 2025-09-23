extends Node2D
class_name CardHandler

## All cards live in this node
@onready var cards_node = $Cards
## Ref to hand TODO make it optional
@onready var hand : Hand = $Areas/Hand

## All managed cards (index is z index)
var cards : Array[Card] = []
## All cards the mouse is over in order
var hovered_cards : Array[Card] = []

## The currenty hovered card
var hovered : Card = null
## The currenty grabbed card
var grabbed : Card = null

## For grabing the offset of card's center and mouse
var offset = Vector2()

func _ready() -> void:
	# add cards for testing
	for i in range(3):
		var card = Card.instantiate(self)
		add_card(card)
		hand.add_card(card)
	hand.update_hand()

## Sets up card to be handled
func add_card(card : Card):
	card.set_z(cards.size())
	cards.push_back(card)
	cards_node.add_child(card)
	update_z_index()

## update z indexes after moveing a card
func update_z_index(from = 0):
	for i in range(from, cards.size()):
		cards[i].set_z(i)

func _process(_delta: float) -> void:
	if grabbed:  # moves the grabbed card to the mouse
		grabbed.set_position_goal(get_global_mouse_position() + offset)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Grab"):
		var card = get_top_hovered()
		if card:
			grab(card)
	if event.is_action_released("Grab"):
		if grabbed:
			if get_top_hovered() == grabbed:
				grabbed.update_status.emit(Card.CardStatus.HOVERED)
			else:
				grabbed.update_status.emit(Card.CardStatus.DEFAULT)
			grabbed = null

## 
func grab(card : Card):
	offset = card.global_position - get_global_mouse_position()
	cards.erase(card)
	add_card(card)
	card.update_status.emit(Card.CardStatus.GRABBED) # Tell card about state change
	card.global_rotation_goal = 0
	grabbed = card

## connects to card signals
func connect_card(card: Card):
	card.connect(card.mouse_entered.get_name(), mouse_entered_card)
	card.connect(card.mouse_exited.get_name(), mouse_exited_card)

## Handle mouse moves over card
func mouse_entered_card(card: Card):
	hovered_cards.push_back(card)
	if !grabbed and (!hovered or hovered.z_fallback < cards.find(card)):
		if hovered:
			hovered.update_status.emit(Card.CardStatus.DEFAULT)
		hovered = card
		card.update_status.emit(Card.CardStatus.HOVERED)

## Handle mouse moves off card
func mouse_exited_card(card: Card):
	hovered_cards.erase(card)
	if card == hovered:
		if card != grabbed:
			card.update_status.emit(Card.CardStatus.DEFAULT)
			hovered = get_top_hovered()
			if hovered:
				hovered.update_status.emit(Card.CardStatus.HOVERED)

## Gets the top hovered card
func get_top_hovered():
	var res : Card = null
	for card in hovered_cards:
		if !res or res.z_fallback < card.z_fallback:
			res = card
	return res

## Helper for keeping list of cards organied in z order
func card_order (a : Card, b : Card): 
	return a.z_fallback > b.z_fallback
