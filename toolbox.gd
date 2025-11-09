extends Control


enum Tools {
	BALL, BUMPER
}
@export var ball_texture : Texture2D
@export var bumper_texture: Texture2D
var scene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Panel/bumper_button.pressed.connect(select_tool.bind(Tools.BUMPER))
	$Panel/ball_button.pressed.connect(select_tool.bind(Tools.BALL))
	scene = get_parent().get_child(0)

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func select_tool(tool):
	global.tool_selected.emit(tool)
	queue_free()
