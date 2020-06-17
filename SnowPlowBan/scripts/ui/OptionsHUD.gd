extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	
	$VBoxContainer/CheckButtonMusic.connect("toggled",AudioManager,"music_toggled")
	$VBoxContainer/CheckButtonSounds.connect("toggled",AudioManager, "sounds_toggled")


