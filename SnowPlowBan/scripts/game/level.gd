extends Spatial


const HOUSE_MDL = preload("res://models/house.obj");
const TREE_MDL = preload("res://models/tree.obj");
const SNOW_MDL = preload("res://models/snow.obj");
const SNOWPLOW_MDL = preload("res://models/snowplow.obj"); 

export var camera_zoom_velocity = 10;
export var camera_zoom_min = 30;
export var camera_zoom_max = 10;
export var camera_vertical_velocity = 0.01;
export var camera_vertical_min = -0.9;
export var camera_vertical_max = -0.1;
export var camera_horizontal_velocity = 0.05;
export var camera_horizontal_min = -1.2;
export var camera_horizontal_max = 1.2;

var scene_center;

var instanced_meshes = [];

# Called when the node enters the scene tree for the first time.
func _ready():
	var level_state = Globals.psengine.get_level_state();
	
	scene_center = $GridMap.map_to_world(level_state.width/2, level_state.height/2, level_state.height/2)
	$Cam_rot.transform.origin= scene_center;
	
	for x in range (0, level_state.width):
		for z in range (0,level_state.height):
			$GridMap.set_cell_item(x,0,z,0);
			for y in range (0, level_state.height-z):
				if y == level_state.height-z-1:
					$GridMap.set_cell_item(x,y+1,z,1,16);
				else :
					$GridMap.set_cell_item(x,y+1,z,0);
	
	generate_dynamic_objects();
	
func clear_instanced_meshes():
	for obj in instanced_meshes:
		if obj != null:
			obj.queue_free();

func generate_dynamic_objects():
	
	clear_instanced_meshes();
	
	var level_state = Globals.psengine.get_level_state();
	
	for cell in level_state.cells:
		for obj in cell.objects:
			var mesh;
			if obj == "House":
				mesh = HOUSE_MDL
			elif obj == "Wall":
				mesh = TREE_MDL
			elif obj == "Snow":
				mesh = SNOW_MDL
			elif obj == "Player":
				mesh = SNOWPLOW_MDL
			else :
				continue;
				
			instantiate_mesh(cell.x,level_state.height-cell.y,cell.y, mesh)

func instantiate_mesh(x,y,z, mesh):
	var pos = $GridMap.map_to_world(x,y,z);
	var house = MeshInstance.new();
	house.mesh = mesh;
	house.transform.origin = pos;
	house.rotate_y(PI/2)
	$GridMap.add_child(house);
	instanced_meshes.append(house);
	

func _input(event):
	if Input.is_action_just_released("cam_zoom_in"):
		$Cam_rot/Camera.translate(Vector3(0,0,-1*camera_zoom_velocity));
		if $Cam_rot/Camera.transform.origin.z < camera_zoom_max:
			$Cam_rot/Camera.transform.origin.z = camera_zoom_max
	if Input.is_action_just_released("cam_zoom_out"):
		$Cam_rot/Camera.translate(Vector3(0,0,1*camera_zoom_velocity));
		if $Cam_rot/Camera.transform.origin.z > camera_zoom_min:
			$Cam_rot/Camera.transform.origin.z = camera_zoom_min
	
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		if event is InputEventMouseMotion:
			var old_rot = $Cam_rot.transform.basis;
			$Cam_rot.rotate_object_local(Vector3.RIGHT, -event.relative.y*camera_vertical_velocity);
			if $Cam_rot.transform.basis.get_euler().x > camera_vertical_max or $Cam_rot.transform.basis.get_euler().x < camera_vertical_min :
				$Cam_rot.transform.basis = old_rot;
			old_rot = $Cam_rot.transform.basis;
			$Cam_rot.rotate_y(event.relative.x*camera_horizontal_velocity);
			if $Cam_rot.transform.basis.get_euler().y > camera_horizontal_max or $Cam_rot.transform.basis.get_euler().y < camera_horizontal_min :
				$Cam_rot.transform.basis = old_rot;

func _process(delta):
	if Input.is_action_just_pressed("ps_up"):
		Globals.psengine.send_input("up");
	if Input.is_action_just_pressed("ps_down"):
		Globals.psengine.send_input("down");
	if Input.is_action_just_pressed("ps_left"):
		Globals.psengine.send_input("left");
	if Input.is_action_just_pressed("ps_right"):
		Globals.psengine.send_input("right");
	if Input.is_action_just_pressed("ps_undo"):
		Globals.psengine.send_input("undo");
	if Input.is_action_just_pressed("ps_restart"):
		Globals.psengine.send_input("restart");
		
	generate_dynamic_objects();



