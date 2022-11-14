extends Node
signal show_debug_stats
var screen_size
var velocities
var positions
var run_mode

# Called when the node enters the scene tree for the first time.
func _ready():
	var node_data
	var color_data_background
	var color_data_optotype
	var save_game = File.new()
	if  save_game.file_exists("user://runs.save"):
		save_game.open("user://runs.save", File.READ)
		node_data = parse_json(save_game.get_line())
		save_game.close()
	
	save_game = File.new()
	if  save_game.file_exists("user://colorBackground.save"):
		save_game.open("user://colorBackground.save", File.READ)
		color_data_background = save_game.get_line()
		color_data_background = Color(color_data_background)
		save_game.close()
	else: 
		color_data_background = Color.white
		
	save_game = File.new()
	if  save_game.file_exists("user://colorOptotype.save"):
		save_game.open("user://colorOptotype.save", File.READ)
		color_data_optotype = save_game.get_line()
		color_data_optotype = Color(color_data_optotype)
		save_game.close()
	else: 
		color_data_optotype = Color.black
	$HUD.initialize(node_data as Dictionary, color_data_background as Color, color_data_optotype as Color)
	$DebugMode.hide()
	screen_size = $Octo.get_viewport_rect().size
	positions = [
		Vector2(0,screen_size.y/2),
		Vector2(0,0),
		Vector2(screen_size.x/2,0),
		Vector2(screen_size.x,0),
		Vector2(screen_size.x,screen_size.y/2),
		Vector2(screen_size.x,screen_size.y),
		Vector2(screen_size.x/2,screen_size.y),
		Vector2(0,screen_size.y)
		]
	velocities = [
		Vector2(screen_size.x,0),
		Vector2(screen_size.x,screen_size.y),
		Vector2(0,screen_size.y),
		Vector2(-screen_size.x,screen_size.y),
		Vector2(-screen_size.x,0),
		Vector2(-screen_size.x,-screen_size.y),
		Vector2(0,-screen_size.y),
		Vector2(screen_size.x,-screen_size.y)
		]
	
func start_game(mode, _list):
	$ColorRect.color = Color($HUD.get_background_color())
	var optotype_color = Color($HUD.get_optotype_color())
	var index = int(mode[2])
	var swing = int(mode[0])
	run_mode = int(mode[1])
	var rotationIteration = 5
	$HUD.hide()
	$Octo.start(positions[index], velocities[index],swing,run_mode,rotationIteration, optotype_color)
	_on_Octo_debug_update()
	if $HUD/CheckBox.pressed:
		$DebugMode.show()
	
func _process(_delta):
	if Input.is_action_pressed("escape"):
		$Octo.stop()
		$DebugMode.hide()
		$HUD.show()
		
func exit():
	var dict = $HUD.getData()
	var save_game = File.new()
	
	save_game.open("user://runs.save", File.WRITE)
	save_game.store_line(to_json(dict))
	save_game.close()
	
	save_game = File.new()
	save_game.open("user://colorBackground.save", File.WRITE)
	save_game.store_line($HUD.get_background_color())
	save_game.close()
	
	save_game = File.new()
	save_game.open("user://colorOptotype.save", File.WRITE)
	save_game.store_line($HUD.get_optotype_color())
	save_game.close()
	
	get_tree().quit()
func _on_Octo_debug_update():
	if $HUD/CheckBox.pressed:
		$DebugMode.velocity = $Octo.speed
		$DebugMode.size = $Octo.size
		$DebugMode.rotationDegree = $Octo.actualRotation
		$DebugMode.userRotationSuccess = $Octo.userRotationSuccess
		$DebugMode.score = $Octo.score
		$DebugMode.iterations = $Octo.iterations
		emit_signal("show_debug_stats")
	else:
		$DebugMode.hide()
	pass # Replace with function body.

