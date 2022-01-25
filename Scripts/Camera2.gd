extends Camera3D

const TURN_SCALAR = 0.04
const MOVE_SCALAR = 5.0
const MOUSE_SENSITIVITY = 0.002

func _ready():
	self.set_process(true)
	self.set_process_input(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

var looker : Vector2 = Vector2.ZERO
func _input(event):
	# Mouse look (only if the mouse is captured).
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		looker.x -= event.relative.x * MOUSE_SENSITIVITY
		looker.y = clamp(looker.y - event.relative.y * MOUSE_SENSITIVITY, -1.57, 1.57)
	if event.is_action_pressed("toggle_mouse_capture"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func getMoveInputVector():
	return Vector3(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_up") - Input.get_action_strength("move_down"),
		Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
	)
func getLookInputVector():
	return Vector2(
		Input.get_action_strength("look_left") - Input.get_action_strength("look_right"),
		Input.get_action_strength("look_up") - Input.get_action_strength("look_down")
	)

func _process(delta):
	var look_input_vec = getLookInputVector()
	var move_input_vec = getMoveInputVector()
	looker.x += TURN_SCALAR * look_input_vec.x
	looker.y += TURN_SCALAR * look_input_vec.y
	transform.basis = Basis()
	self.rotate_object_local(Vector3.UP   , looker.x)
	self.rotate_object_local(Vector3.RIGHT, looker.y)
	self.transform.origin += transform.basis.x * delta * MOVE_SCALAR * move_input_vec.x
	self.transform.origin += transform.basis.y * delta * MOVE_SCALAR * move_input_vec.y
	self.transform.origin += transform.basis.z * delta * MOVE_SCALAR * move_input_vec.z
