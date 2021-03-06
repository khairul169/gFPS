extends Camera

# Editor variable
export var enabled = true;
export var bob_speed = 0.8;
export var bob_factor = 0.2;
export var min_weight = 1.2;
export var interpolation = 4.0;

# Node
onready var controller = get_parent();

# Variable
var bob_cycle = 0.0;
var cam_translation = Vector3();

func _ready():
	pass

func _process(delta):
	if (!enabled || !controller):
		return;
	
	# Get horizontal velocity from controller
	var hv = controller.linear_velocity;
	hv.y = 0.0;
	
	# Calculate bob weight
	var bob_weight = min((hv.length()/controller.MoveSpeed), 10.0);
	
	# Cycle bob angle
	if (bob_weight >= min_weight):
		bob_cycle = fmod(bob_cycle + 360 * delta * bob_weight * bob_speed, 360.0);
	else:
		bob_cycle = 0.0;
	
	var factor = bob_factor * bob_weight;
	var cam_transform = cam_translation;
	
	# Calculate bob vector
	cam_transform -= transform.basis.x * sin(deg2rad(bob_cycle)) * factor;
	cam_transform += transform.basis.y * abs(sin(deg2rad(bob_cycle))) * factor * 1.5;
	
	# Interpolate cam translation
	cam_translation = cam_translation.linear_interpolate(Vector3(), interpolation * delta);
	
	# Set camera transform
	transform.origin = transform.origin.linear_interpolate(cam_transform, interpolation * delta);

func set_camera_translation(vec):
	# Fix with camera pitch
	vec.z = -vec.y * sin(deg2rad(controller.camera_rotation[0]));
	vec.y = vec.y * cos(deg2rad(controller.camera_rotation[0]));
	
	# Apply camera translation
	cam_translation = vec;

func set_camera_animation(anims):
	pass # TODO
