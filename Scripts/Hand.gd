extends Node2D
class_name Hand

@onready var curve : Curve2D = $Path2D.curve

var cards : Array[Card] = []
var hovered : int = -1

signal update

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func add_card(card : Card):
	cards.push_back(card)
	update.emit()

func remove_card(card : Card):
	cards.erase(card)
	update.emit()

func card_pos(ind : int):
	var pos
	if hovered == -1:
		pos = curve.samplef(float(ind + 1) / (cards.size() + 1))
		pos = to_global(pos)
	else:
		pass
		pos = curve.sample_baked(curve.get_baked_length() * (ind + 1) / (cards.size() + 1))
	return pos
