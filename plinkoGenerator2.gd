@tool
extends Node

@export var width: float = 100:
	set(value):
		width = value
		_on_value_changed()
@export var height: float = 100:
	set(value):
		height = value
		_on_value_changed()
@export var pinResolution: int = 10:
	set(value):
		pinResolution = value
		_on_value_changed()
@export var radius: float = 10:
	set(value):
		radius = value
		_on_value_changed()
@export var layers: int = 4:
	set(value):
		layers = value
		_on_value_changed()
@export var wallThickness: int = 10:
	set(value):
		wallThickness = value
		_on_value_changed()
@export var topHeight: float = 10:
	set(value):
		topHeight = value
		_on_value_changed()
@export var chamberDepth: float = 10:
	set(value):
		chamberDepth = value
		_on_value_changed()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_plinko()



func _on_value_changed() -> void:
	if Engine.is_editor_hint():
		print("value changed")
		create_plinko()

func create_plinko() -> void:
	# delete previous plinko board
	for child in get_children():
		child.queue_free()
		# generate new plinko board
	create_plinko_side_walls()
	create_plinko_chambers()
	create_plinko_pins()

func create_plinko_pins() -> void:	
	if layers > 1:
		var points: PackedVector2Array = create_circle_poly()
		var xGap: float = width / (layers - 1)
		var yGap: float = height / (layers - 1)
		for i in layers:
			var xOffset: float = xGap * i / 2.0
			var y: float = height - yGap * i
			for j in layers - i:
				var x: float = xOffset + j * xGap
				var newStaticBody = StaticBody2D.new()
				
				var newPinColl = CollisionPolygon2D.new()
				newPinColl.polygon = points
				newPinColl.position = Vector2(x,y)
				newStaticBody.add_child(newPinColl)
				var newPin = Polygon2D.new()
				newPin.polygon = points
				newPin.position = Vector2(x,y)
				newStaticBody.add_child(newPin)
				add_child(newStaticBody)

func create_plinko_side_walls() -> void:
	var gap: float = width / (layers - 1)
	var points = PackedVector2Array()

	points.append(Vector2(-gap, height + chamberDepth)) #bottom right point
	points.append(Vector2(-gap, height)) #lower-medium right point
	points.append(Vector2((width / 2) - gap, 0)) #upper-meduim right point
	points.append(Vector2((width / 2) - gap, -topHeight)) #top right
	points.append(Vector2((width / 2) - (gap + wallThickness), -topHeight)) #top left
	points.append(Vector2((width / 2) - (gap + wallThickness), 0)) #upper-medium left point
	points.append(Vector2(-(gap + wallThickness), height)) #lower-medium left point
	points.append(Vector2(-(gap + wallThickness), height + chamberDepth)) #bottom left point

	var newStaticBody
	var newPinColl
	var newPin
	# add walls to tree
	newStaticBody = StaticBody2D.new()
	newPinColl = CollisionPolygon2D.new()
	newPinColl.polygon = points
	#newPinColl.position = Vector2()
	newStaticBody.add_child(newPinColl)
	newPin = Polygon2D.new()
	newPin.polygon = points
	#newPin.position = Vector2(x,y)
	newStaticBody.add_child(newPin)
	add_child(newStaticBody)
	
	# flip walls
	var pointsMirrored = PackedVector2Array()
	for point in points:
		pointsMirrored.append(Vector2(-point.x + width, point.y))
	
	# add flipped walls to tree
	newStaticBody = StaticBody2D.new()
	newPinColl = CollisionPolygon2D.new()
	newPinColl.polygon = pointsMirrored
	#newPinColl.position = Vector2()
	newStaticBody.add_child(newPinColl)
	newPin = Polygon2D.new()
	newPin.polygon = pointsMirrored
	#newPin.position = Vector2(x,y)
	newStaticBody.add_child(newPin)
	add_child(newStaticBody)
	

func create_plinko_chambers() -> void:
	var wallRadius: float = 0
	if wallThickness > radius * 2:
		wallRadius = radius
	else:
		wallRadius = wallThickness / 2.0
	wallRadius = max(wallRadius, 1)
	
	var gap: float = width / (layers - 1)
	for i in layers:
		var xMid: float = i * gap
		var points = PackedVector2Array()
		points.append(Vector2(xMid - wallRadius, height)) # bottom right
		points.append(Vector2(xMid - wallRadius, height + chamberDepth)) # top right
		points.append(Vector2(xMid + wallRadius, height + chamberDepth)) # top left
		points.append(Vector2(xMid + wallRadius, height)) # bottom right
		
		var newStaticBody = StaticBody2D.new()
		var newChamberColl = CollisionPolygon2D.new()
		newChamberColl.polygon = points
		newStaticBody.add_child(newChamberColl)
		var newChamber = Polygon2D.new()
		newChamber.polygon = points
		newStaticBody.add_child(newChamber)
		add_child(newStaticBody)

func create_circle_poly() -> PackedVector2Array:
	var points = PackedVector2Array()
	for i in range(pinResolution + 1):
		var point = ((2 * PI) / pinResolution) * i
		points.push_back(Vector2(cos(point), sin(point)) * radius)
	return points
