class_name CardInfo
extends Node

var text := "Text"
var art := "Art"

func _to_string() -> String:
	return "<CardInfo " + text + " " + art + ">"
