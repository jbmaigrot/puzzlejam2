extends Spatial


# Called when the node enters the scene tree for the first time.
func _ready():
	var level_state = Globals.psengine.get_level_state();
	
	for x in range (0, level_state.width):
		for z in range (0,level_state.height):
			$GridMap.set_cell_item(x,0,z,0);
			for y in range (0, level_state.height-z):
				if y == level_state.height-z-1:
					$GridMap.set_cell_item(x,y+1,z,1,0);
				else :
					$GridMap.set_cell_item(x,y+1,z,0);
			
	

