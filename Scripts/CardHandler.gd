extends Node2D
class_name CardHandler

## All cards live in this node
@onready var cards_node = $Cards
## Ref to hand TODO make it optional
@onready var hand : Hand = $Areas/Hand

var draw_pile : Array[CardInfo] = []
var discard_pile : Array[CardInfo] = []

## All managed cards 
var cards : Array[Card] = []

func _ready() -> void:
	# testing
	for ind in 10:
		var info = CardInfo.new()
		info.art = str(ind)
		info.text = str(ind)
		draw_pile.append(info)

## Sets up card to be handled
func add_card(card : Card):
	if card.get_parent() != cards_node:
		cards_node.add_child(card)
	cards.push_back(card)

func _process(_delta: float) -> void:
	pass
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Test"):
		draw()

func draw():
	var info
	if draw_pile.size() == 0:
		if discard_pile.size() > 0:
			shuffle()
		else:
			return
	info = draw_pile.pop_front()
	var card = Card.create(info)
	add_card(card)
	card.handler = self
	card.display.global_position = $Areas/DrawPile/Background.position + Global.CARD_DIMENSIONS / 2
	card.display.scale = Vector2.ZERO
	card.csm.next_state.emit(CardState.StateName.HANDDEFAULT)

func shuffle():
	## TODO random number system
	draw_pile = discard_pile
	discard_pile = []

func discard(card : Card):
	var info = card.info
	card.info = null
	discard_pile.push_front(info)
	card.queue_free()
