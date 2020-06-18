extends Spatial


const HOUSE_MDL = preload("res://models/house.obj");
const TREE_MDL = preload("res://models/tree.obj");
const SNOW_MDL = preload("res://models/snow.obj");
const SNOWPLOW_MDL = preload("res://models/snowplow.obj"); 
const TRACKS_MDL = preload("res://models/tracks.obj"); 
const FLAG_MDL = preload("res://models/flag.obj"); 

export var camera_zoom_velocity = 10;
export var camera_zoom_min = 30;
export var camera_zoom_max = 10;
export var camera_vertical_velocity = 0.001;
export var camera_vertical_min = -0.9;
export var camera_vertical_max = -0.1;
export var camera_horizontal_velocity = 0.005;
export var camera_horizontal_min = -1.2;
export var camera_horizontal_max = 1.2;

var scene_center;
var opposite_scene_center;

var instanced_meshes = [];

var input_count = 0;
var input_repeat_timer = 0;
var last_input = "";

# Called when the node enters the scene tree for the first time.
func _ready():
	reset_level();
	
func reset_level():
	$GridMap.clear();
	
	var level_state = Globals.psengine.get_level_state();
	
	scene_center = $GridMap.map_to_world(level_state.width/2, level_state.height/2, level_state.height/2)
	$Cam_rot.transform.origin= scene_center;
	opposite_scene_center = scene_center;
	opposite_scene_center.x = -scene_center.x
	
	for x in range (0, level_state.width):
		for z in range (0,level_state.height):
			$GridMap.set_cell_item(x,0,z,2);
			for y in range (0, level_state.height-z):
				if y == level_state.height-z-1:
					$GridMap.set_cell_item(x,y+1,z,1,16);
				else :
					$GridMap.set_cell_item(x,y+1,z,2);
	
	generate_dynamic_objects();
	
	input_count = 0;

#this doesn't seem to work
func set_game_camera_position(game_position):
	if game_position:
		$Cam_rot.set_target(scene_center);
	else:
		$Cam_rot.set_target(opposite_scene_center);
	

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
			elif obj == "Track":
				mesh = TRACKS_MDL
			elif obj == "Snow":
				mesh = SNOW_MDL
			elif obj == "Player":
				mesh = SNOWPLOW_MDL
			elif obj == "Flag":
				mesh = FLAG_MDL
			elif obj == "SnowHouse":
				instantiate_mesh(cell.x,level_state.height-cell.y,cell.y, SNOW_MDL)
				mesh = HOUSE_MDL
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
		input_count += 1;
		last_input = "ps_up";
		input_repeat_timer = 0.5;
	if Input.is_action_just_pressed("ps_down"):
		Globals.psengine.send_input("down");
		input_count += 1;
		last_input = "ps_down";
		input_repeat_timer = 0.5;
	if Input.is_action_just_pressed("ps_left"):
		Globals.psengine.send_input("left");
		input_count += 1;
		last_input = "ps_left";
		input_repeat_timer = 0.5;
	if Input.is_action_just_pressed("ps_right"):
		Globals.psengine.send_input("right");
		input_count += 1;
		last_input = "ps_right";
		input_repeat_timer = 0.5;
	if Input.is_action_just_pressed("ps_undo"):
		Globals.psengine.send_input("undo");
		input_count -= 1;
		if input_count < 0:
			input_count = 0;
		last_input = "ps_undo";
		input_repeat_timer = 0.5;
	if Input.is_action_just_pressed("ps_restart"):
		Globals.psengine.send_input("restart");
		input_count = 0;
	
	if Input.is_action_just_pressed("ui_cancel"):
		Globals.load_pause_menu();
	
	if last_input != "" && Input.is_action_pressed(last_input):
		input_repeat_timer -= delta;
		if input_repeat_timer <= 0:
			input_count += 1;
			input_repeat_timer = 0.3;
			match last_input:
				"ps_up":
					Globals.psengine.send_input("up");
				"ps_down":
					Globals.psengine.send_input("down");
				"ps_left":
					Globals.psengine.send_input("left");
				"ps_right":
					Globals.psengine.send_input("right");
				"ps_undo":
					Globals.psengine.send_input("undo");
					input_count -= 2; # because it was incremented before this match
	else:
		last_input = "";
	
	generate_dynamic_objects();
	
	if Globals.psengine.is_level_complete() :
		Globals.load_completion_menu();
		
	#print(input_count);



