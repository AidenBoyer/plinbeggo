@tool
extends Node

@onready var Plinko_Pin : PackedScene = preload("res://Plinko_Pin.tscn")

@export var layers: int = 4:
	set(value):
		layers = value
		_on_value_changed()
@export var height: float = 100:
	set(value):
		height = value
		_on_value_changed()
@export var width: float = 100:
	set(value):
		width = value
		_on_value_changed()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_create_plinko()



func _on_value_changed() -> void:
	if Engine.is_editor_hint():
		print("value changed")
		_create_plinko()

func _create_plinko() -> void:
	if not Plinko_Pin:
		push_warning("No PackedScene assigned!")
		return
	
	for child in get_children():
		child.queue_free()

	if layers > 1:
		var xGap: float = width / (layers - 1)
		var yGap: float = height / (layers - 1)
		for i in layers:
			var xOffset: float = xGap * i / 2.0
			var y: float = height - yGap * i
			for j in layers - i:
				var x: float = xOffset + j * xGap
				var newPin = Plinko_Pin.instantiate()
				newPin.position = Vector2(x,y)
				add_child(newPin)
	#pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
