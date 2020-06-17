extends Spatial

export var interp_speed = 0.5;

var origin_vector = Vector3(0,0,0);
var target = Vector3(0,0,0);
var interp = false;
var t = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	
func _process(delta):
	if interp :
		t += delta * interp_speed
		transform.origin = origin_vector.linear_interpolate(target, t)
		if t >= 1:
			interp = false;
			transform.origin = target

func set_target(new_target):
	origin_vector = transform.origin;
	target = new_target;
	interp = true;
	t = 0
