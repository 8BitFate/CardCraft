extends CardSet
class_name Hand

var hovered : int = -1
@export var vertival_offset : Curve
@export var max_vertical_offset := 150
@export var max_width := 1200
@export var overlap := 0

# signal update

func _ready() -> void:
	super()
	cards_node = $"."

func add_card(card : Card):
	super(card)
	#card.display.global_position = $Areas/DrawPile/Background.position + Global.CARD_DIMENSIONS / 2
	# card.display.scale = Vector2.ZERO
	card.csm.next_state.emit(CardState.StateName.HANDDEFAULT)
	# update.emit()

func remove_card(card : Card):
	super(card)
	# update.emit()

#func transform_card(card : Card):
	#var ind = cards.find(card)
	#card.set_order(ind)
	#var width = ((cards.size() + 1) * Global.CARD_WIDTH) - (cards.size() - 1) * overlap
	#width = clamp(width, 0, max_width)
	#var x : float
	#var y : float
	#var ratio = float(ind + 1) / (cards.size() + 1)
	#x = width * ratio
	#y = vertival_offset.sample(ratio) * max_vertical_offset * -1
	#var pos = Vector2(x - width / 2 ,y)
	#pos = to_global(pos)
	#card.move_to(pos)


func hover(card : Card):
	hovered = cards.find(card)
	# update.emit()

func unhover():
	hovered = -1
	# update.emit()
