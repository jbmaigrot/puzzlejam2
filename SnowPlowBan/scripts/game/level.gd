extends Spatial


# Called when the node enters the scene tree for the first time.
func _ready():
		
	for x in range (0, 5):
		for z in range (0,5):
			$GridMap.set_cell_item(x,0,z,0);
			
	for x in range (0, 5):
			$GridMap.set_cell_item(x,1,0,1,x);

