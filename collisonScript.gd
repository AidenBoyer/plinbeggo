@tool
extends Node2D

@onready var poly_2d = $Polygon2D
@onready var coll_poly_2d = $CollisionPolygon2D

@export var refresh: bool = false:
	set(value):
		refresh = value
		_sync_poly()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_sync_poly()

func _sync_poly() -> void:
	if coll_poly_2d and poly_2d:
		print("synced collision poly")
		coll_poly_2d.polygon = poly_2d.polygon
		coll_poly_2d.scale = poly_2d.scale


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
