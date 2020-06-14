extends Node

const GAME_RULES_FILE = "res://psionic/snowplowban_rules.tres"

const MAIN_MENU_PATH = "res://scenes/ui/MainMenu.tscn"
const LEVEL_SELECT_MENU_PATH = "res://scenes/ui/LevelSelectMenu.tscn"


var psengine;

# Called when the node enters the scene tree for the first time.
func _ready():
	psengine = GDPSEngine.new()
	psengine.load_game_from_file_path(GAME_RULES_FILE)

func load_new_scene(new_scene_path):
	get_tree().change_scene(new_scene_path)

func load_main_menu():
	load_new_scene(MAIN_MENU_PATH)
	
func load_level_select_menu():
	load_new_scene(LEVEL_SELECT_MENU_PATH)

func load_level(level_index):
	psengine.load_level(level_index);
	
	var st = psengine.get_level_state();
	pass
