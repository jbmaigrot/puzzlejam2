extends Spatial


const HOUSE_MDL = preload("res://models/house.obj");
const TREE_MDL = preload("res://models/tree.obj");

var scene_center;

export var camera_zoom_velocity = 10;
export var camera_vertical_velocity = 10;
export var camera_horizontal_velocity = 10;

# Called when the node enters the scene tree for the first time.
func _ready():
	var level_state = Globals.psengine.get_level_state();
	
	scene_center = $GridMap.map_to_world(level_state.width/2, level_state.height/2, level_state.height/2)
	$Cam_rot_h.transform.origin= scene_center;
	
	for x in range (0, level_state.width):
		for z in range (0,level_state.height):
			$GridMap.set_cell_item(x,0,z,0);
			for y in range (0, level_state.height-z):
				if y == level_state.height-z-1:
					$GridMap.set_cell_item(x,y+1,z,1,16);
				else :
					$GridMap.set_cell_item(x,y+1,z,0);
	
	for cell in level_state.cells:
		for obj in cell.objects:
			var mesh;
			if obj == "House":
				mesh = HOUSE_MDL
			elif obj == "Wall":
				mesh = TREE_MDL
			else :
				continue;
				
			instantiate_mesh(cell.x,level_state.height-cell.y,cell.y, mesh)

func _process(delta):
	if Input.is_action_pressed("ps_up"):
		$Cam_rot_h/Cam_rot_v/Camera.translate(Vector3(0,0,-delta*camera_zoom_velocity));
	if Input.is_action_pressed("ps_down"):
		$Cam_rot_h/Cam_rot_v/Camera.translate(Vector3(0,0,delta*camera_zoom_velocity));
	if Input.is_action_pressed("ps_left"):
		$Cam_rot_h/Cam_rot_v.rotate_object_local(Vector3.RIGHT, delta*camera_vertical_velocity);
	if Input.is_action_pressed("ps_right"):
		$Cam_rot_h/Cam_rot_v.rotate_object_local(Vector3.RIGHT, -delta*camera_vertical_velocity);
	if Input.is_action_pressed("ps_undo"):
		$Cam_rot_h/Cam_rot_v.rotate_y(delta*camera_horizontal_velocity);
	if Input.is_action_pressed("ps_restart"):
		$Cam_rot_h/Cam_rot_v.rotate_y(-delta*camera_horizontal_velocity);

func instantiate_mesh(x,y,z, mesh):
	var pos = $GridMap.map_to_world(x,y,z);
	var house = MeshInstance.new();
	house.mesh = mesh;
	house.transform.origin = pos;
	house.transform.rotated(Vector3.UP, 0.7)
	$GridMap.add_child(house);
	

