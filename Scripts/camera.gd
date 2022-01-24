extends Camera3D

const MOUSE_SENSITIVITY = 0.002
const MOVE_SPEED = 0.6

var rot = Vector3()
var velocity = Vector3()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	# Mouse look (only if the mouse is captured).
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# Horizontal mouse look.
		rot.y -= event.relative.x * MOUSE_SENSITIVITY
		# Vertical mouse look.
		rot.x = clamp(rot.x - event.relative.y * MOUSE_SENSITIVITY, -1.57, 1.57)
		#Original Code:
		#transform.basis = Basis(rot)
		transform.basis = Basis(Quaternion(rot))
	if event.is_action_pressed("toggle_mouse_capture"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

#Basis.xform(Vector3) from: https://github.com/godotengine/godot/blob/9e0973ca23423f270df3589e2766a0918e409526/core/math/basis.h
	#Vector3 Basis::xform(const Vector3 &p_vector) const {
	#	return Vector3(
	#		elements[0].dot(p_vector),
	#		elements[1].dot(p_vector),
	#		elements[2].dot(p_vector));
	#}
func Basis_xform(b : Basis, v : Vector3):
	return Vector3(b.x.dot(v),b.y.dot(v),b.z.dot(v))

func _process(delta):
	var motion = Vector3(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		#Original Code:
		#0,
		Input.get_action_strength("move_up") - Input.get_action_strength("move_down"),
		Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
	)
	# Normalize motion to prevent diagonal movement from being
	# `sqrt(2)` times faster than straight movement.
	motion = motion.normalized()
	#Original Code:
	#velocity += MOVE_SPEED * delta * transform.basis.xform(motion)
	velocity += MOVE_SPEED * delta * Basis_xform(transform.basis, motion)
	velocity *= 0.85# Adds drag to slow down when no keys are pressed.
	#Original Code:
	#translation += velocity
	self.transform = self.transform.translated(velocity)
