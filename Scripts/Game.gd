extends Node2D
class_name Game

func _ready() -> void:
	get_viewport().physics_object_picking_sort = true
	get_viewport().physics_object_picking_first_only = true

func _process(_delta: float) -> void:
	pass
