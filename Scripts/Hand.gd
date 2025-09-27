extends Node2D
class_name Hand

## Editor inputs
@export var pos_curve: Curve
@export var rot_curve: Curve

@export var default_x_offset := -10
@export var y_max_offset := -100
@export var max_tilt := PI / 10

## TODO usefull variables
@onready var max_width = Global.viewport_rect.size.x / 2
@onready var center = Global.viewport_rect.size * Vector2(0.5, 0.95)

## List of cards managed by the hand
var cards : Array[Card] = []

##
@export var card_hanfler : CardHandler

## Hand configuration data that can be reused
@onready var hand_conf = {
	count		= 0,
	get_pos = func (_ind) : return Vector2.ONE,
	get_rot = func (ind) : return max_tilt * rot_curve.sample((ind + 1) / float(hand_conf.count + 1)),
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

## Updates a catds position
func update_card_position(card : Card):
	update_hand_conf()
	var ind = cards.find(card)
	if ind >= 0:
		card.move_to(hand_conf.get_pos.call(ind))
		card.rotation(hand_conf.get_rot.call(ind))
		card_hanfler.cards_node.move_child(card, ind)

## Update 
func update_hand():
	update_hand_conf()
	for card in cards:
		update_card_position(card)

## calculates variables for card positioning
func update_hand_conf():
	if hand_conf.count != cards.size():
		hand_conf.count = cards.size()
		var x_offset = default_x_offset
		var cards_width = hand_conf.count * Global.CARD_WIDTH
		var hand_width = cards_width + ((hand_conf.count - 1) * x_offset)
		if  hand_width > max_width:
			x_offset = (max_width - hand_width) / (hand_conf.count - 1)
		var card_with_offset = x_offset + Global.CARD_WIDTH
		var first_pos = center - Vector2(
			roundf(card_with_offset * hand_conf.count - x_offset) / 2,
			0)
		var sample_incr = 1.0 / (hand_conf.count - 1)
		hand_conf.get_pos = func (ind):
			if hand_conf.count > 1:
				return first_pos + Vector2(
					ind * card_with_offset,
					y_max_offset * pos_curve.sample(ind * sample_incr))
			else:
				return first_pos

## Add card to hand
func add_card(card: Card):
	cards.append(card)
	update_hand()
	
## remove card from hand
func remove_card(card : Card):
	cards.erase(card)
	update_hand()
