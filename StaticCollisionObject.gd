extends StaticBody2D

@onready var poly_2d = $Polygon2D
@onready var coll_poly_2d = $CollisionPolygon2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coll_poly_2d.polygon = poly_2d.polygon


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
