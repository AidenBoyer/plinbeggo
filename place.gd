extends Node

	
enum Tools {
	BALL, BUMPER
}


@export var Ball: PackedScene
@export var Bumper: PackedScene
@export var Toolbox: PackedScene
@export var ball_texture: Texture2D
@export var bumper_texture: Texture2D
@export var grid_size : int
@onready var placing = Guide.new()
@onready var menu_is_open = false
@onready var frozen = true

var placement_position : Vector2
func _ready():
	global.tool_selected.connect(select_tool)
	pass

func _input(event):
	if event.is_action_pressed("open_menu") && !menu_is_open:
		var menu = Toolbox.instantiate()
		add_child(menu)
		menu_is_open = true
		pass
	if event.is_action_pressed("click"):
		if(placing != null):
			if(placing.type == Tools.BALL):
				var new_ball = Ball.instantiate()
				new_ball.position = placement_position
				if(frozen):
					new_ball.get_child(0).freeze = true
				$scene.add_child(new_ball)
			if(placing.type == Tools.BUMPER):
				var new_bumper = Bumper.instantiate()
				new_bumper.position = placement_position
				$scene.add_child(new_bumper)	
			placing.type = null
			if(placing.sprite != null):
				placing.sprite.queue_free()	
				placing.sprite = null
	if event.is_action_pressed("release"):
		if(frozen):
			for child in $scene.get_children():
				if(child.get_child(0) is RigidBody2D):
					child.get_child(0).freeze = false
			frozen = false
		else: if(!frozen):
			for child in $scene.get_children():
				
				if(child.get_child(0) is RigidBody2D):
					child.get_child(0).freeze = true
			frozen = true
	if event.is_action_pressed("reset"):
		for child in $scene.get_children():
			child.queue_free()
		
func _process(_delta):
	set_placement_position()
	
	
	if(placing.type != null):
		placing.sprite.scale = Vector2(0.25, 0.25)
		placing.sprite.position = placement_position
	
func select_tool(tool):
	
	match tool:
		Tools.BALL:
			placing.sprite = Sprite2D.new()
			placing.sprite.texture = ball_texture
			placing.type = Tools.BALL
			pass
		Tools.BUMPER:
			placing.sprite = Sprite2D.new()
			placing.sprite.texture = bumper_texture
			placing.type = Tools.BUMPER	
			
			pass
	$scene.add_child(placing.sprite)
	menu_is_open = false
	pass

#snap to grid 
func set_placement_position():
	placement_position = get_viewport().get_mouse_position()
	#placement_position= (get_viewport().get_mouse_position().snapped(Vector2(grid_size, grid_size)))
	#
