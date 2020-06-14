extends Node

const GAME_RULES_FILE = "res://psionic/snowplowban_rules.tres"

var psengine;

# Called when the node enters the scene tree for the first time.
func _ready():
	psengine = GDPSEngine.new()
	psengine.load_game_from_file_path(GAME_RULES_FILE)
	
	var st = psengine.get_level_state();
	pass # Replace with function body.
