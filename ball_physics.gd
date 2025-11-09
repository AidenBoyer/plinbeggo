extends RigidBody2D

signal tool_selected(tool)

@export var bounciness : int
	
func _integrate_forces(state):
	if(state.get_contact_count()):
		print(state.get_contact_local_normal(0))
		state.apply_impulse(state.get_contact_local_normal(0) * bounciness, state.get_contact_collider_position(0))
