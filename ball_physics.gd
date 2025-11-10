extends RigidBody2D

signal tool_selected(tool)

@export var bumperBounciness : int = 500
@export var defaultBounciness : int = 50

	
func _integrate_forces(state):
	if(state.get_contact_count()):
		if(state.get_contact_collider_object(0).get_parent().has_meta(&"type") && state.get_contact_collider_object(0).get_parent().get_meta(&"type") == "Bumper"):
			#print(state.get_contact_local_normal(0))
			state.apply_impulse(state.get_contact_local_normal(0) * bumperBounciness, state.get_contact_collider_position(0))
			$BumperNoise.play()
		else:
			state.apply_impulse(state.get_contact_local_normal(0) * defaultBounciness, state.get_contact_collider_position(0))
			$RandomNoisePlayer.play()

func _ready():
	$VisibleOnScreenNotifier2D.screen_exited.connect(handle_death)

func handle_death():
	freeze = true
	$DeathNoise.play()
	await get_tree().create_timer(1.0).timeout
	
	queue_free()
	
