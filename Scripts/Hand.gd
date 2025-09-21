extends Node2D
class_name Hand

@export var pos_curve: Curve
@export var rot_curve: Curve

@export var default_x_offset := -10
@export var y_max_offset := -100
@export var max_tilt := PI / 10

@onready var max_width = Global.viewport_rect.size.x / 2
@onready var center = Global.viewport_rect.size * Vector2(0.5, 0.95)

var cards : Array[Card] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func get_card_hand_position():
	pass

func card_released(card: Card):
	cards.erase(card)
	cards.append(card)
	update_card_position()

func update_card_position():
	var count = cards.size()
	var x_offset = default_x_offset
	var card_width = count * Global.CARD_WIDTH
	if card_width + ((count - 1) * x_offset) > max_width:
		x_offset = (max_width - card_width) / (count - 1)
	var first = center - Vector2(roundf(Global.CARD_WIDTH * count + x_offset * (count - 1)) / 2, 0)
	for ind in cards.size():
		var card = cards[ind]
		if(card):
			var pos = first + Vector2(
				ind * (x_offset + Global.CARD_WIDTH),
				y_max_offset * pos_curve.sample(float(count - ind - 1) / (count - 1) ))
			card.set_position_goal(pos)
			var rot = max_tilt * rot_curve.sample(ind / float(count - 1))
			card.global_rotation_goal = rot
			card.set_index(ind)
		
	
func add_card(card: Card):
	cards.append(card)
	card.connect(card.released.get_name(), card_released)
